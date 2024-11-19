//
//  File.swift
//  
//
//  Created by Stephan on 26.04.24.
//

import StoreKit
import RustXcframework


public func ios_iap_products(request:Int64, products:RustVec<RustString>)
{
    Task {
        do {
            var productIds:[String] = []
            for p in products {
                productIds.append(p.as_str().toString())
            }
            
            let products = try await Product.products(for: productIds)
            
            let rust_products = RustVec<IosIapProduct>()
            
            for product in products {
                rust_products.push(value: try await convert_product(product))
            }
            
            products_received(request, IosIapProductsResponse.done(rust_products))
        } catch {
            products_received(request, IosIapProductsResponse.error(error.localizedDescription))
        }
    }
}

public func ios_iap_purchase(request:Int64, id: RustString) {
    Task {
        do {
            let productIds = [id.toString()]
            let products = try await Product.products(for: productIds)
            
            if products.isEmpty {
                return purchase_processed(request, IosIapPurchaseResponse.unknown(id.toString()))
            }
            
            let purchase  = try await products.first!.purchase()
            
            let result = switch purchase {
            case .success(let transactionResult):
                IosIapPurchaseResponse.success(try convert_transaction(transactionResult.unsafePayloadValue))
            case .userCancelled:
                IosIapPurchaseResponse.canceled(id.toString())
            case .pending:
                IosIapPurchaseResponse.pending(id.toString())
            }
            
            purchase_processed(request, result)
        } catch {
            purchase_processed(request, IosIapPurchaseResponse.error(error.localizedDescription))
        }
    }
}

public func ios_iap_init()
{
    TransactionObserver.init()
}

public func ios_iap_transaction_finish(request: Int64, transaction_id: UInt64) {
    Task {
        do {
            for await t in Transaction.unfinished {
                // ignore un-signed/verified transactions
                guard case .verified(let transaction) = t else {
                    continue
                }
                
                if transaction.id == transaction_id {
                    await transaction.finish()
                    transaction_finished(request, IosIapTransactionFinishResponse.finished(try convert_transaction(transaction)))
                    return;
                }
            }
            
            transaction_finished(request, IosIapTransactionFinishResponse.unknown(transaction_id))
        } catch {
            transaction_finished(request, IosIapTransactionFinishResponse.error(error.localizedDescription))
        }
    }
}

public func ios_iap_transactions_all(request: Int64) {
    Task {
        do {
            var transactions = RustVec<IosIapTransaction>.init()
            
            for await t in Transaction.all {
                //only return signed/verified transactions
                guard case .verified(let transaction) = t else {
                    continue
                }
                
                transactions.push(value:try convert_transaction(transaction))
            }
            
            all_transactions(request, IosIapTransactionResponse.done(transactions))
        }catch {
            all_transactions(request, IosIapTransactionResponse.error(error.localizedDescription))
        }
    }
}

public func ios_iap_transactions_current_entitlements(request: Int64) {
    Task {
        do{
            var transactions = RustVec<IosIapTransaction>.init()
            
            for await t in Transaction.currentEntitlements {
                //only return signed/verified transactions
                guard case .verified(let transaction) = t else {
                    continue
                }
                
                transactions.push(value:try convert_transaction(transaction))
            }
            
            current_entitlements(request,IosIapTransactionResponse.done(transactions))
        } catch {
            current_entitlements(request,IosIapTransactionResponse.error(error.localizedDescription))
        }
    }
}

func convert_product(_ product: (Product)) async throws -> IosIapProduct {
    let type = if product.type == Product.ProductType.consumable {
        IosIapProductType.new_consumable(false)
    } else if product.type == Product.ProductType.nonConsumable {
        IosIapProductType.new_consumable(true)
    } else if product.type == Product.ProductType.nonRenewable {
        IosIapProductType.new_non_renewable()
    } else {
        IosIapProductType.new_auto_renewable()
    }
    
    var rust_product = IosIapProduct.new(product.id, product.displayPrice, product.displayName, product.description, Double(truncating: product.price as NSNumber), type)
    
    if let sub = product.subscription {
        let unit = switch sub.subscriptionPeriod.unit {
        case .day:
            IosIapSubscriptionPeriodUnit.day()
        case .week:
            IosIapSubscriptionPeriodUnit.week()
        case .month:
            IosIapSubscriptionPeriodUnit.month()
        case .year:
            IosIapSubscriptionPeriodUnit.year()
        }
        
        let period = IosIapSubscriptionPeriod.new(unit, Int32(sub.subscriptionPeriod.value))
        
        let status = try await sub.status
        
        let rust_status = RustVec<IosIapSubscriptionStatus>()
        for s in status {
            let renewalState = switch s.state {
            case .subscribed:
                IosIapSubscriptionRenewalState.subscribed()
            case .expired:
                IosIapSubscriptionRenewalState.expired()
            case .inGracePeriod:
                IosIapSubscriptionRenewalState.in_grace_period()
            case .inBillingRetryPeriod:
                IosIapSubscriptionRenewalState.in_billing_retry_period()
            case .revoked:
                IosIapSubscriptionRenewalState.revoked()
            default:
                throw NSError(domain: "invalid renewal state", code: 1, userInfo: nil)
            }
            guard case .verified(let transaction) = s.transaction else {
                continue
            }
            rust_status.push(value: IosIapSubscriptionStatus.new(renewalState,try convert_transaction(transaction)))
        }
        
        let subscription = IosIapSubscriptionInfo.new(sub.subscriptionGroupID, period, try await sub.isEligibleForIntroOffer, rust_status)
        
        IosIapProduct.subscription(rust_product, subscription)
    }
    
    return rust_product
}

public func convert_transaction(_ transaction: (Transaction)) throws -> IosIapTransaction {
    let type = if transaction.productType == Product.ProductType.consumable {
       IosIapProductType.new_consumable(false)
    } else if transaction.productType == Product.ProductType.nonConsumable {
       IosIapProductType.new_consumable(true)
    } else if transaction.productType == Product.ProductType.nonRenewable {
       IosIapProductType.new_non_renewable()
    } else {
       IosIapProductType.new_auto_renewable()
    }

    let reason = if transaction.reason == Transaction.Reason.purchase {
       IosIapTransactionReason.purchase()
    } else  {
       IosIapTransactionReason.renewal()
    }

    let env = if transaction.environment == AppStore.Environment.xcode {
       IosIapEnvironment.xcode()
    } else if transaction.environment == AppStore.Environment.sandbox {
       IosIapEnvironment.sandbox()
    } else {
       IosIapEnvironment.production()
    }

    let store = IosIapStorefront.storefront(transaction.storefront.id, transaction.storefront.countryCode)
    
    let jsonRepresentation = String(decoding: transaction.jsonRepresentation, as: UTF8.self)

    var t  = IosIapTransaction.new_transaction(
        transaction.id,
        transaction.productID,
        transaction.appBundleID,
        UInt64(transaction.purchaseDate.timeIntervalSince1970),
        UInt64(transaction.originalPurchaseDate.timeIntervalSince1970),
        Int32(transaction.purchasedQuantity),
        transaction.storefrontCountryCode,
        UInt64(transaction.signedDate.timeIntervalSince1970),
        transaction.isUpgraded,
        transaction.originalID,
        jsonRepresentation,
        type,
        reason,
        env,
        store)
    
    if let appAccountToken = transaction.appAccountToken {
        IosIapTransaction.app_account_token(t, appAccountToken.uuidString)
    }
    
    if let currencyCode = transaction.currencyCode {
        IosIapTransaction.add_currency_code(t, currencyCode)
    }
    
    if let currency = transaction.currency {
        IosIapTransaction.add_currency(t, IosIapCurrency.new(currency.identifier, currency.isISOCurrency))
    }
   
    if let revocationDate = transaction.revocationDate {
       IosIapTransaction.add_revocation(t, UInt64(revocationDate.timeIntervalSince1970))
    }
    
    if let revocationReason = transaction.revocationReason {
        let revocationReason = switch revocationReason {
        case .developerIssue:
            IosIapRevocationReason.developer_issue()
        case .other:
            IosIapRevocationReason.other()
        default:
            throw NSError(domain: "invalid revocation reason", code: 2, userInfo: nil)
        }
        
        IosIapTransaction.revocation_reason(t, revocationReason)
    }

    if let expirationDate = transaction.expirationDate {
       IosIapTransaction.add_expiration(t, UInt64(expirationDate.timeIntervalSince1970))
    }
    
    if let subscriptionGroupID = transaction.subscriptionGroupID {
        IosIapTransaction.subscription_group_id(t, subscriptionGroupID)
    }
    
    if let webOrderLineItemID = transaction.webOrderLineItemID {
        IosIapTransaction.web_order_line_item_id(t, webOrderLineItemID)
    }

    return t
}
