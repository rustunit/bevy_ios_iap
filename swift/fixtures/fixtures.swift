// Dev-only: emits the JSON fixtures that `src/wire.rs` asserts against, using the very same
// `JSONEncoder` and DTO definitions the shim uses in production.
//
// It is concatenated with `swift/BevyIosIap.swift` into a single compilation unit (the DTOs are
// file-private) and run by `just swift-fixtures`. Nothing here ships to a device.

private let outputDirectory = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "tests/fixtures"

private func write(_ name: String, _ contents: String) {
    let path = "\(outputDirectory)/\(name)"
    try! contents.write(toFile: path, atomically: true, encoding: .utf8)
    print("wrote \(path)")
}

private let fullTransaction = TransactionDto(
    id: 2_000_000_123_456_789,
    original_id: 2_000_000_987_654_321,
    product_id: "com.rustunit.zoolitaire.levelunlock",
    app_bundle_id: "com.rustunit.zoolitaire",
    purchase_date: 1_712_345_678,
    original_purchase_date: 1_712_345_600,
    revocation_date: 1_712_999_999,
    expiration_date: 1_715_000_000,
    purchased_quantity: 3,
    storefront_country_code: "USA",
    signed_date: 1_712_345_679,
    is_upgraded: true,
    // deliberately contains quotes: it is JSON nested inside JSON
    json_representation: "{\"quoted\":\"payload\"}",
    product_type: "non_consumable",
    storefront: StorefrontDto(id: "143441", country_code: "USA"),
    reason: "purchase",
    environment: "sandbox",
    currency: CurrencyDto(identifier: "USD", is_iso_currency: true),
    revocation_reason: "developer_issue",
    app_account_token: "11112222-3333-4444-5555-666677778888",
    web_order_line_item_id: "web-order-1",
    subscription_group_id: "group-1")

/// What a pre-iOS-17 device produces: every optional absent, so the keys are omitted entirely.
private let minimalTransaction = TransactionDto(
    id: 1,
    original_id: 1,
    product_id: "com.rustunit.zoolitaire.coins",
    app_bundle_id: "com.rustunit.zoolitaire",
    purchase_date: 1_712_345_678,
    original_purchase_date: 1_712_345_678,
    revocation_date: nil,
    expiration_date: nil,
    purchased_quantity: 1,
    storefront_country_code: "DEU",
    signed_date: 1_712_345_678,
    is_upgraded: false,
    json_representation: "{}",
    product_type: "consumable",
    storefront: nil,
    reason: nil,
    environment: "production",
    currency: nil,
    revocation_reason: nil,
    app_account_token: nil,
    web_order_line_item_id: nil,
    subscription_group_id: nil)

private let subscriptionTransaction = TransactionDto(
    id: 42,
    original_id: 42,
    product_id: "com.rustunit.zoolitaire.subscription",
    app_bundle_id: "com.rustunit.zoolitaire",
    purchase_date: 1_712_345_678,
    original_purchase_date: 1_712_345_678,
    revocation_date: nil,
    expiration_date: 1_715_000_000,
    purchased_quantity: 1,
    storefront_country_code: "DEU",
    signed_date: 1_712_345_678,
    is_upgraded: false,
    json_representation: "{}",
    product_type: "auto_renewable",
    storefront: nil,
    reason: nil,
    environment: "production",
    currency: nil,
    revocation_reason: nil,
    app_account_token: nil,
    web_order_line_item_id: nil,
    subscription_group_id: "group-1")

write("transaction_full.json", encode(fullTransaction))
write("transaction_minimal.json", encode(minimalTransaction))

write(
    "products.json",
    encode(
        ProductsResponseDto(products: [
            ProductDto(
                id: "com.rustunit.zoolitaire.levelunlock",
                display_price: "$1.99",
                display_name: "Level Unlock",
                description: "Unlocks all levels",
                price: 1.99,
                product_type: "non_consumable",
                subscription: nil),
            ProductDto(
                id: "com.rustunit.zoolitaire.subscription",
                display_price: "$4.99",
                display_name: "Zoo Pass",
                description: "Monthly pass",
                price: 4.99,
                product_type: "auto_renewable",
                subscription: SubscriptionInfoDto(
                    group_id: "group-1",
                    period: SubscriptionPeriodDto(unit: "month", value: 1),
                    is_eligible_for_intro_offer: true,
                    state: [
                        SubscriptionStatusDto(
                            state: "in_grace_period", transaction: subscriptionTransaction)
                    ])),
        ])))

write(
    "products_error.json",
    encode(ProductsResponseDto(error: "The operation couldn't be completed.")))

write(
    "transactions.json",
    encode(TransactionsResponseDto(transactions: [minimalTransaction, fullTransaction])))

private var canceled = PurchaseResponseDto(kind: "canceled")
canceled.product_id = "com.rustunit.zoolitaire.levelunlock"
write("purchase_canceled.json", encode(canceled))

private var storeKitError = PurchaseResponseDto(kind: "storekit_error")
storeKitError.message = "outer description"
storeKitError.storekit_error = "network_error"
storeKitError.storekit_error_message = "inner network failure"
write("purchase_storekit_error.json", encode(storeKitError))

private var purchaseError = PurchaseResponseDto(kind: "purchase_error")
purchaseError.purchase_error = "product_unavailable"
purchaseError.message = "product unavailable"
write("purchase_error.json", encode(purchaseError))

private var finishUnknown = TransactionFinishResponseDto(kind: "unknown")
finishUnknown.unknown_id = 99
write("finish_unknown.json", encode(finishUnknown))
