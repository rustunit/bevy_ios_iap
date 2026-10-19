// StoreKit 2 shim.
//
// StoreKit 2 (`Product`, `Transaction`) is Swift-only - it has no Objective-C runtime presence,
// so it cannot be reached through objc2 the way GameKit can. This file is the whole Swift
// surface of the crate: `build.rs` compiles it with `swiftc` and links it statically, which is
// why the crate no longer ships a Swift package.
//
// Everything crosses the boundary as JSON. The shapes here mirror the `*Dto` structs in
// `src/native.rs`; keep the two in sync.

import Foundation
import StoreKit

// MARK: - Wire format

private struct StorefrontDto: Encodable {
    let id: String
    let country_code: String
}

private struct CurrencyDto: Encodable {
    let identifier: String
    let is_iso_currency: Bool
}

private struct TransactionDto: Encodable {
    let id: UInt64
    let original_id: UInt64
    let product_id: String
    let app_bundle_id: String
    let purchase_date: UInt64
    let original_purchase_date: UInt64
    let revocation_date: UInt64?
    let expiration_date: UInt64?
    let purchased_quantity: Int32
    let storefront_country_code: String
    let signed_date: UInt64
    let is_upgraded: Bool
    let json_representation: String
    let product_type: String
    /// `nil` maps to `Ios17Specific::NotAvailable`
    let storefront: StorefrontDto?
    /// `nil` maps to `Ios17Specific::NotAvailable`
    let reason: String?
    let environment: String
    let currency: CurrencyDto?
    let revocation_reason: String?
    let app_account_token: String?
    let web_order_line_item_id: String?
    let subscription_group_id: String?
}

private struct SubscriptionPeriodDto: Encodable {
    let unit: String
    let value: Int32
}

private struct SubscriptionStatusDto: Encodable {
    let state: String
    let transaction: TransactionDto
}

private struct SubscriptionInfoDto: Encodable {
    let group_id: String
    let period: SubscriptionPeriodDto
    let is_eligible_for_intro_offer: Bool
    let state: [SubscriptionStatusDto]
}

private struct ProductDto: Encodable {
    let id: String
    let display_price: String
    let display_name: String
    let description: String
    let price: Double
    let product_type: String
    let subscription: SubscriptionInfoDto?
}

private struct ProductsResponseDto: Encodable {
    var products: [ProductDto]?
    var error: String?
}

private struct TransactionsResponseDto: Encodable {
    var transactions: [TransactionDto]?
    var error: String?
}

private struct TransactionFinishResponseDto: Encodable {
    let kind: String
    var transaction: TransactionDto?
    var unknown_id: UInt64?
    var message: String?
}

private struct PurchaseResponseDto: Encodable {
    let kind: String
    var transaction: TransactionDto?
    var product_id: String?
    var message: String?
    var purchase_error: String?
    var storekit_error: String?
    var storekit_error_message: String?
}

/// Rust turns any payload it cannot parse into an error response, so an encoding failure still
/// completes the request rather than leaving the caller waiting forever.
///
/// `.sortedKeys` because the default key order varies per process, which would make the
/// checked-in test fixtures churn on every regeneration.
private func encode<T: Encodable>(_ value: T) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys

    guard let data = try? encoder.encode(value) else {
        return "failed to encode response"
    }
    return String(decoding: data, as: UTF8.self)
}

// MARK: - Conversion

private func productTypeName(_ type: Product.ProductType) -> String {
    if type == .consumable {
        return "consumable"
    } else if type == .nonConsumable {
        return "non_consumable"
    } else if type == .nonRenewable {
        return "non_renewable"
    }
    return "auto_renewable"
}

private func secondsSinceEpoch(_ date: Date) -> UInt64 {
    UInt64(max(0, date.timeIntervalSince1970))
}

private func convert(transaction: Transaction) throws -> TransactionDto {
    let environment: String
    if transaction.environment == .xcode {
        environment = "xcode"
    } else if transaction.environment == .sandbox {
        environment = "sandbox"
    } else {
        environment = "production"
    }

    var storefront: StorefrontDto?
    var reason: String?
    if #available(iOS 17.0, *) {
        storefront = StorefrontDto(
            id: transaction.storefront.id,
            country_code: transaction.storefront.countryCode)
        reason = transaction.reason == .purchase ? "purchase" : "renewal"
    }

    var revocationReason: String?
    if let value = transaction.revocationReason {
        switch value {
        case .developerIssue:
            revocationReason = "developer_issue"
        case .other:
            revocationReason = "other"
        default:
            throw NSError(domain: "invalid revocation reason", code: 2, userInfo: nil)
        }
    }

    var currency: CurrencyDto?
    if let value = transaction.currency {
        currency = CurrencyDto(
            identifier: value.identifier, is_iso_currency: value.isISOCurrency)
    }

    return TransactionDto(
        id: transaction.id,
        original_id: transaction.originalID,
        product_id: transaction.productID,
        app_bundle_id: transaction.appBundleID,
        purchase_date: secondsSinceEpoch(transaction.purchaseDate),
        original_purchase_date: secondsSinceEpoch(transaction.originalPurchaseDate),
        revocation_date: transaction.revocationDate.map(secondsSinceEpoch),
        expiration_date: transaction.expirationDate.map(secondsSinceEpoch),
        purchased_quantity: Int32(transaction.purchasedQuantity),
        storefront_country_code: transaction.storefrontCountryCode,
        signed_date: secondsSinceEpoch(transaction.signedDate),
        is_upgraded: transaction.isUpgraded,
        json_representation: String(decoding: transaction.jsonRepresentation, as: UTF8.self),
        product_type: productTypeName(transaction.productType),
        storefront: storefront,
        reason: reason,
        environment: environment,
        currency: currency,
        revocation_reason: revocationReason,
        app_account_token: transaction.appAccountToken?.uuidString,
        web_order_line_item_id: transaction.webOrderLineItemID,
        subscription_group_id: transaction.subscriptionGroupID)
}

private func convert(subscription: Product.SubscriptionInfo) async throws -> SubscriptionInfoDto {
    let unit: String
    switch subscription.subscriptionPeriod.unit {
    case .day: unit = "day"
    case .week: unit = "week"
    case .month: unit = "month"
    case .year: unit = "year"
    @unknown default: unit = "day"
    }

    var states: [SubscriptionStatusDto] = []
    for status in try await subscription.status {
        let state: String
        switch status.state {
        case .subscribed: state = "subscribed"
        case .expired: state = "expired"
        case .inGracePeriod: state = "in_grace_period"
        case .inBillingRetryPeriod: state = "in_billing_retry_period"
        case .revoked: state = "revoked"
        default:
            throw NSError(domain: "invalid renewal state", code: 1, userInfo: nil)
        }

        // unverified transactions are dropped, same as everywhere else
        guard case .verified(let transaction) = status.transaction else {
            continue
        }

        states.append(
            SubscriptionStatusDto(state: state, transaction: try convert(transaction: transaction)))
    }

    return SubscriptionInfoDto(
        group_id: subscription.subscriptionGroupID,
        period: SubscriptionPeriodDto(
            unit: unit, value: Int32(subscription.subscriptionPeriod.value)),
        is_eligible_for_intro_offer: await subscription.isEligibleForIntroOffer,
        state: states)
}

private func convert(product: Product) async throws -> ProductDto {
    var subscription: SubscriptionInfoDto?
    if let info = product.subscription {
        subscription = try await convert(subscription: info)
    }

    return ProductDto(
        id: product.id,
        display_price: product.displayPrice,
        display_name: product.displayName,
        description: product.description,
        price: Double(truncating: product.price as NSNumber),
        product_type: productTypeName(product.type),
        subscription: subscription)
}

/// Plain `default` rather than `@unknown default`: StoreKit keeps adding cases (Xcode 26 added
/// `.paymentMethodBindingConfigurationRequired`) and the crate has to keep building against
/// older and newer SDKs alike.
private func purchaseErrorName(_ error: Product.PurchaseError) -> String {
    switch error {
    case .invalidQuantity: return "invalid_quantity"
    case .productUnavailable: return "product_unavailable"
    case .purchaseNotAllowed: return "purchase_not_allowed"
    case .ineligibleForOffer: return "ineligible_for_offer"
    case .invalidOfferIdentifier: return "invalid_offer_identifier"
    case .invalidOfferPrice: return "invalid_offer_price"
    case .invalidOfferSignature: return "invalid_offer_signature"
    case .missingOfferParameters: return "missing_offer_parameters"
    default: return "unknown"
    }
}

private func storeKitErrorResponse(_ error: StoreKitError) -> PurchaseResponseDto {
    var response = PurchaseResponseDto(kind: "storekit_error")
    response.message = error.localizedDescription

    switch error {
    case .unknown:
        response.storekit_error = "unknown"
    case .userCancelled:
        response.storekit_error = "user_cancelled"
    case .networkError(let inner):
        response.storekit_error = "network_error"
        response.storekit_error_message = inner.localizedDescription
    case .systemError(let inner):
        response.storekit_error = "system_error"
        response.storekit_error_message = inner.localizedDescription
    case .notAvailableInStorefront:
        response.storekit_error = "not_available_in_storefront"
    case .notEntitled:
        response.storekit_error = "not_entitled"
    default:
        response.storekit_error = "unknown"
    }

    return response
}

// MARK: - Transaction observer

/// `Transaction.updates` has to be consumed for the whole lifetime of the app, so the task is
/// parked in a global. Re-initializing would start a second consumer and duplicate every event.
private final class TransactionObserver {
    private var updates: Task<Void, Never>?

    init() {
        updates = Task(priority: .background) {
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else {
                    continue
                }
                guard let dto = try? convert(transaction: transaction) else {
                    continue
                }
                bevy_ios_iap_transaction_update(encode(dto))
            }
        }
    }

    deinit {
        updates?.cancel()
    }
}

nonisolated(unsafe) private var observer: TransactionObserver?
private let observerLock = NSLock()

// MARK: - Entry points

@_cdecl("bevy_ios_iap_swift_init")
public func bevy_ios_iap_swift_init() {
    observerLock.lock()
    defer { observerLock.unlock() }

    if observer == nil {
        observer = TransactionObserver()
    }
}

@_cdecl("bevy_ios_iap_swift_products")
public func bevy_ios_iap_swift_products(request: Int64, idsJson: UnsafePointer<CChar>) {
    let ids = (try? JSONDecoder().decode([String].self, from: Data(String(cString: idsJson).utf8)))
    guard let ids else {
        bevy_ios_iap_products_received(
            request, encode(ProductsResponseDto(error: "could not decode product ids")))
        return
    }

    Task {
        do {
            var products: [ProductDto] = []
            for product in try await Product.products(for: ids) {
                products.append(try await convert(product: product))
            }
            bevy_ios_iap_products_received(request, encode(ProductsResponseDto(products: products)))
        } catch {
            bevy_ios_iap_products_received(
                request, encode(ProductsResponseDto(error: error.localizedDescription)))
        }
    }
}

@_cdecl("bevy_ios_iap_swift_purchase")
public func bevy_ios_iap_swift_purchase(request: Int64, productId: UnsafePointer<CChar>) {
    let id = String(cString: productId)

    Task {
        do {
            let products = try await Product.products(for: [id])

            guard let product = products.first else {
                var response = PurchaseResponseDto(kind: "unknown")
                response.product_id = id
                bevy_ios_iap_purchase_processed(request, encode(response))
                return
            }

            var response: PurchaseResponseDto
            switch try await product.purchase() {
            case .success(let result):
                response = PurchaseResponseDto(kind: "success")
                response.transaction = try convert(transaction: result.unsafePayloadValue)
            case .userCancelled:
                response = PurchaseResponseDto(kind: "canceled")
                response.product_id = id
            case .pending:
                response = PurchaseResponseDto(kind: "pending")
                response.product_id = id
            @unknown default:
                response = PurchaseResponseDto(kind: "unknown")
                response.product_id = id
            }

            bevy_ios_iap_purchase_processed(request, encode(response))
        } catch let error as Product.PurchaseError {
            var response = PurchaseResponseDto(kind: "purchase_error")
            response.purchase_error = purchaseErrorName(error)
            response.message = error.localizedDescription
            bevy_ios_iap_purchase_processed(request, encode(response))
        } catch let error as StoreKitError {
            bevy_ios_iap_purchase_processed(request, encode(storeKitErrorResponse(error)))
        } catch {
            var response = PurchaseResponseDto(kind: "error")
            response.message = error.localizedDescription
            bevy_ios_iap_purchase_processed(request, encode(response))
        }
    }
}

@_cdecl("bevy_ios_iap_swift_transactions_all")
public func bevy_ios_iap_swift_transactions_all(request: Int64) {
    Task {
        do {
            var transactions: [TransactionDto] = []
            for await result in Transaction.all {
                guard case .verified(let transaction) = result else {
                    continue
                }
                transactions.append(try convert(transaction: transaction))
            }
            bevy_ios_iap_all_transactions(
                request, encode(TransactionsResponseDto(transactions: transactions)))
        } catch {
            bevy_ios_iap_all_transactions(
                request, encode(TransactionsResponseDto(error: error.localizedDescription)))
        }
    }
}

@_cdecl("bevy_ios_iap_swift_transactions_current_entitlements")
public func bevy_ios_iap_swift_transactions_current_entitlements(request: Int64) {
    Task {
        do {
            var transactions: [TransactionDto] = []
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    continue
                }
                transactions.append(try convert(transaction: transaction))
            }
            bevy_ios_iap_current_entitlements(
                request, encode(TransactionsResponseDto(transactions: transactions)))
        } catch {
            bevy_ios_iap_current_entitlements(
                request, encode(TransactionsResponseDto(error: error.localizedDescription)))
        }
    }
}

@_cdecl("bevy_ios_iap_swift_transaction_finish")
public func bevy_ios_iap_swift_transaction_finish(request: Int64, transactionId: UInt64) {
    Task {
        do {
            for await result in Transaction.unfinished {
                guard case .verified(let transaction) = result else {
                    continue
                }

                if transaction.id == transactionId {
                    await transaction.finish()
                    var response = TransactionFinishResponseDto(kind: "finished")
                    response.transaction = try convert(transaction: transaction)
                    bevy_ios_iap_transaction_finished(request, encode(response))
                    return
                }
            }

            var response = TransactionFinishResponseDto(kind: "unknown")
            response.unknown_id = transactionId
            bevy_ios_iap_transaction_finished(request, encode(response))
        } catch {
            var response = TransactionFinishResponseDto(kind: "error")
            response.message = error.localizedDescription
            bevy_ios_iap_transaction_finished(request, encode(response))
        }
    }
}
