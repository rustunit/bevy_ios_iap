//! The JSON contract with the Swift StoreKit 2 shim.
//!
//! These types mirror what `swift/BevyIosIap.swift` encodes; keep the two in sync. They are
//! compiled on every platform - not just iOS - so the contract can be exercised by the tests at
//! the bottom of this file, which are fed payloads produced by the real Swift encoder.
//!
//! `Option` fields are `#[serde(default)]` throughout because Swift's `JSONEncoder` omits `nil`
//! rather than writing `null`.

use serde::Deserialize;

use crate::{
    IosIapCurrency, IosIapEnvironment, IosIapProduct, IosIapProductType, IosIapProductsResponse,
    IosIapPurchaseError, IosIapPurchaseResponse, IosIapRevocationReason, IosIapStoreKitError,
    IosIapStorefront, IosIapSubscriptionInfo, IosIapSubscriptionPeriod,
    IosIapSubscriptionPeriodUnit, IosIapSubscriptionRenewalState, IosIapSubscriptionStatus,
    IosIapTransactionFinishResponse, IosIapTransactionReason, IosIapTransactionResponse,
    transaction::{Ios17Specific, IosIapTransaction},
};

#[derive(Deserialize)]
pub struct StorefrontDto {
    id: String,
    country_code: String,
}

#[derive(Deserialize)]
pub struct CurrencyDto {
    identifier: String,
    is_iso_currency: bool,
}

#[derive(Deserialize)]
pub struct TransactionDto {
    id: u64,
    original_id: u64,
    product_id: String,
    app_bundle_id: String,
    purchase_date: u64,
    original_purchase_date: u64,
    #[serde(default)]
    revocation_date: Option<u64>,
    #[serde(default)]
    expiration_date: Option<u64>,
    purchased_quantity: i32,
    storefront_country_code: String,
    signed_date: u64,
    is_upgraded: bool,
    json_representation: String,
    product_type: String,
    /// absent below iOS 17
    #[serde(default)]
    storefront: Option<StorefrontDto>,
    /// absent below iOS 17
    #[serde(default)]
    reason: Option<String>,
    environment: String,
    #[serde(default)]
    currency: Option<CurrencyDto>,
    #[serde(default)]
    revocation_reason: Option<String>,
    #[serde(default)]
    app_account_token: Option<String>,
    #[serde(default)]
    web_order_line_item_id: Option<String>,
    #[serde(default)]
    subscription_group_id: Option<String>,
}

#[derive(Deserialize)]
pub struct SubscriptionPeriodDto {
    unit: String,
    value: i32,
}

#[derive(Deserialize)]
pub struct SubscriptionStatusDto {
    state: String,
    transaction: TransactionDto,
}

#[derive(Deserialize)]
pub struct SubscriptionInfoDto {
    group_id: String,
    period: SubscriptionPeriodDto,
    is_eligible_for_intro_offer: bool,
    state: Vec<SubscriptionStatusDto>,
}

#[derive(Deserialize)]
pub struct ProductDto {
    id: String,
    display_price: String,
    display_name: String,
    description: String,
    price: f64,
    product_type: String,
    #[serde(default)]
    subscription: Option<SubscriptionInfoDto>,
}

#[derive(Deserialize)]
pub struct ProductsResponseDto {
    #[serde(default)]
    products: Option<Vec<ProductDto>>,
    #[serde(default)]
    error: Option<String>,
}

#[derive(Deserialize)]
pub struct TransactionsResponseDto {
    #[serde(default)]
    transactions: Option<Vec<TransactionDto>>,
    #[serde(default)]
    error: Option<String>,
}

#[derive(Deserialize)]
pub struct TransactionFinishResponseDto {
    kind: String,
    #[serde(default)]
    transaction: Option<TransactionDto>,
    #[serde(default)]
    unknown_id: Option<u64>,
    #[serde(default)]
    message: Option<String>,
}

#[derive(Deserialize)]
pub struct PurchaseResponseDto {
    kind: String,
    #[serde(default)]
    transaction: Option<TransactionDto>,
    #[serde(default)]
    product_id: Option<String>,
    #[serde(default)]
    message: Option<String>,
    #[serde(default)]
    purchase_error: Option<String>,
    #[serde(default)]
    storekit_error: Option<String>,
    #[serde(default)]
    storekit_error_message: Option<String>,
}

// MARK: - conversion

/// The shim only ever sends the names matched below. Falling back instead of failing keeps a
/// StoreKit case added by a future SDK from taking a whole purchase down with it.
fn product_type(name: &str) -> IosIapProductType {
    match name {
        "consumable" => IosIapProductType::new_consumable(false),
        "non_consumable" => IosIapProductType::new_consumable(true),
        "non_renewable" => IosIapProductType::new_non_renewable(),
        _ => IosIapProductType::new_auto_renewable(),
    }
}

impl TransactionDto {
    pub fn convert(self) -> IosIapTransaction {
        IosIapTransaction {
            id: self.id,
            original_id: self.original_id,
            product_id: self.product_id,
            app_bundle_id: self.app_bundle_id,
            purchase_date: self.purchase_date,
            original_purchase_date: self.original_purchase_date,
            revocation_date: self.revocation_date,
            expiration_date: self.expiration_date,
            purchased_quantity: self.purchased_quantity,
            storefront_country_code: self.storefront_country_code,
            signed_date: self.signed_date,
            is_upgraded: self.is_upgraded,
            json_representation: self.json_representation,
            product_type: product_type(&self.product_type),
            storefront: match self.storefront {
                Some(s) => {
                    Ios17Specific::Available(IosIapStorefront::storefront(s.id, s.country_code))
                }
                None => Ios17Specific::NotAvailable,
            },
            reason: match self.reason.as_deref() {
                Some("purchase") => Ios17Specific::Available(IosIapTransactionReason::purchase()),
                Some(_) => Ios17Specific::Available(IosIapTransactionReason::renewal()),
                None => Ios17Specific::NotAvailable,
            },
            environment: match self.environment.as_str() {
                "xcode" => IosIapEnvironment::xcode(),
                "sandbox" => IosIapEnvironment::sandbox(),
                _ => IosIapEnvironment::production(),
            },
            currency: self
                .currency
                .map(|c| IosIapCurrency::new(c.identifier, c.is_iso_currency)),
            revocation_reason: self.revocation_reason.as_deref().map(|r| match r {
                "developer_issue" => IosIapRevocationReason::developer_issue(),
                _ => IosIapRevocationReason::other(),
            }),
            app_account_token: self.app_account_token,
            web_order_line_item_id: self.web_order_line_item_id,
            subscription_group_id: self.subscription_group_id,
        }
    }
}

impl SubscriptionInfoDto {
    fn convert(self) -> IosIapSubscriptionInfo {
        let period = IosIapSubscriptionPeriod::new(
            match self.period.unit.as_str() {
                "week" => IosIapSubscriptionPeriodUnit::week(),
                "month" => IosIapSubscriptionPeriodUnit::month(),
                "year" => IosIapSubscriptionPeriodUnit::year(),
                _ => IosIapSubscriptionPeriodUnit::day(),
            },
            self.period.value,
        );

        let state = self
            .state
            .into_iter()
            .map(|s| {
                IosIapSubscriptionStatus::new(
                    match s.state.as_str() {
                        "expired" => IosIapSubscriptionRenewalState::expired(),
                        "in_grace_period" => IosIapSubscriptionRenewalState::in_grace_period(),
                        "in_billing_retry_period" => {
                            IosIapSubscriptionRenewalState::in_billing_retry_period()
                        }
                        "revoked" => IosIapSubscriptionRenewalState::revoked(),
                        _ => IosIapSubscriptionRenewalState::subscribed(),
                    },
                    s.transaction.convert(),
                )
            })
            .collect();

        IosIapSubscriptionInfo::new(
            self.group_id,
            period,
            self.is_eligible_for_intro_offer,
            state,
        )
    }
}

impl ProductDto {
    fn convert(self) -> IosIapProduct {
        let subscription = self.subscription.map(SubscriptionInfoDto::convert);

        let mut product = IosIapProduct::new(
            self.id,
            self.display_price,
            self.display_name,
            self.description,
            self.price,
            product_type(&self.product_type),
        );

        if let Some(subscription) = subscription {
            IosIapProduct::subscription(&mut product, subscription);
        }

        product
    }
}

impl ProductsResponseDto {
    pub fn convert(self) -> IosIapProductsResponse {
        match self.error {
            Some(e) => IosIapProductsResponse::error(e),
            None => IosIapProductsResponse::done(
                self.products
                    .unwrap_or_default()
                    .into_iter()
                    .map(ProductDto::convert)
                    .collect(),
            ),
        }
    }
}

impl TransactionsResponseDto {
    pub fn convert(self) -> IosIapTransactionResponse {
        match self.error {
            Some(e) => IosIapTransactionResponse::error(e),
            None => IosIapTransactionResponse::done(
                self.transactions
                    .unwrap_or_default()
                    .into_iter()
                    .map(TransactionDto::convert)
                    .collect(),
            ),
        }
    }
}

impl TransactionFinishResponseDto {
    pub fn convert(self) -> IosIapTransactionFinishResponse {
        match self.kind.as_str() {
            "finished" => match self.transaction {
                Some(t) => IosIapTransactionFinishResponse::finished(t.convert()),
                None => IosIapTransactionFinishResponse::error(
                    "iap: finished response without a transaction".into(),
                ),
            },
            "unknown" => {
                IosIapTransactionFinishResponse::unknown(self.unknown_id.unwrap_or_default())
            }
            _ => IosIapTransactionFinishResponse::error(
                self.message
                    .unwrap_or_else(|| format!("iap: unexpected finish response '{}'", self.kind)),
            ),
        }
    }
}

impl PurchaseResponseDto {
    pub fn convert(self) -> IosIapPurchaseResponse {
        let product_id = self.product_id.unwrap_or_default();

        match self.kind.as_str() {
            "success" => match self.transaction {
                Some(t) => IosIapPurchaseResponse::success(t.convert()),
                None => IosIapPurchaseResponse::error(
                    "iap: success response without a transaction".into(),
                ),
            },
            "canceled" => IosIapPurchaseResponse::canceled(product_id),
            "pending" => IosIapPurchaseResponse::pending(product_id),
            "unknown" => IosIapPurchaseResponse::unknown(product_id),
            "purchase_error" => IosIapPurchaseResponse::purchase_error(
                purchase_error(self.purchase_error.as_deref().unwrap_or_default()),
                self.message.unwrap_or_default(),
            ),
            "storekit_error" => IosIapPurchaseResponse::storekit_error(
                storekit_error(
                    self.storekit_error.as_deref().unwrap_or_default(),
                    self.storekit_error_message.unwrap_or_default(),
                ),
                self.message.unwrap_or_default(),
            ),
            _ => {
                IosIapPurchaseResponse::error(self.message.unwrap_or_else(|| {
                    format!("iap: unexpected purchase response '{}'", self.kind)
                }))
            }
        }
    }
}

fn purchase_error(name: &str) -> IosIapPurchaseError {
    match name {
        "invalid_quantity" => IosIapPurchaseError::invalid_quantity(),
        "product_unavailable" => IosIapPurchaseError::product_unavailable(),
        "purchase_not_allowed" => IosIapPurchaseError::purchase_not_allowed(),
        "ineligible_for_offer" => IosIapPurchaseError::ineligible_for_offer(),
        "invalid_offer_identifier" => IosIapPurchaseError::invalid_offer_identifier(),
        "invalid_offer_price" => IosIapPurchaseError::invalid_offer_price(),
        "invalid_offer_signature" => IosIapPurchaseError::invalid_offer_signature(),
        "missing_offer_parameters" => IosIapPurchaseError::missing_offer_parameters(),
        _ => IosIapPurchaseError::unknown_purchase_error(),
    }
}

fn storekit_error(name: &str, message: String) -> IosIapStoreKitError {
    match name {
        "user_cancelled" => IosIapStoreKitError::user_cancelled(),
        "network_error" => IosIapStoreKitError::network_error(message),
        "system_error" => IosIapStoreKitError::system_error(message),
        "not_available_in_storefront" => IosIapStoreKitError::not_available_in_storefront(),
        "not_entitled" => IosIapStoreKitError::not_entitled(),
        _ => IosIapStoreKitError::unknown(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Every payload below was produced by the real `JSONEncoder` in `swift/BevyIosIap.swift`
    /// (see `just swift-fixtures`), so these tests fail if either side of the contract drifts.
    mod fixtures {
        pub const TRANSACTION_FULL: &str = include_str!("../tests/fixtures/transaction_full.json");
        pub const TRANSACTION_MINIMAL: &str =
            include_str!("../tests/fixtures/transaction_minimal.json");
        pub const PRODUCTS: &str = include_str!("../tests/fixtures/products.json");
        pub const PRODUCTS_ERROR: &str = include_str!("../tests/fixtures/products_error.json");
        pub const TRANSACTIONS: &str = include_str!("../tests/fixtures/transactions.json");
        pub const PURCHASE_CANCELED: &str =
            include_str!("../tests/fixtures/purchase_canceled.json");
        pub const PURCHASE_STOREKIT_ERROR: &str =
            include_str!("../tests/fixtures/purchase_storekit_error.json");
        pub const PURCHASE_ERROR: &str = include_str!("../tests/fixtures/purchase_error.json");
        pub const FINISH_UNKNOWN: &str = include_str!("../tests/fixtures/finish_unknown.json");
    }

    fn transaction(json: &str) -> IosIapTransaction {
        serde_json::from_str::<TransactionDto>(json)
            .expect("swift payload should parse")
            .convert()
    }

    #[test]
    fn parses_a_fully_populated_transaction() {
        let t = transaction(fixtures::TRANSACTION_FULL);

        assert_eq!(t.id, 2000000123456789);
        assert_eq!(t.original_id, 2000000987654321);
        assert_eq!(t.product_id, "com.rustunit.zoolitaire.levelunlock");
        assert_eq!(t.app_bundle_id, "com.rustunit.zoolitaire");
        assert_eq!(t.purchase_date, 1712345678);
        assert_eq!(t.original_purchase_date, 1712345600);
        assert_eq!(t.revocation_date, Some(1712999999));
        assert_eq!(t.expiration_date, Some(1715000000));
        assert_eq!(t.purchased_quantity, 3);
        assert_eq!(t.storefront_country_code, "USA");
        assert_eq!(t.signed_date, 1712345679);
        assert!(t.is_upgraded);
        assert_eq!(t.json_representation, "{\"quoted\":\"payload\"}");
        assert_eq!(
            t.app_account_token.as_deref(),
            Some("11112222-3333-4444-5555-666677778888")
        );
        assert_eq!(t.web_order_line_item_id.as_deref(), Some("web-order-1"));
        assert_eq!(t.subscription_group_id.as_deref(), Some("group-1"));

        assert!(matches!(t.product_type, IosIapProductType::NonConsumable));
        assert!(matches!(t.environment, IosIapEnvironment::Sandbox));
        assert!(matches!(
            t.revocation_reason,
            Some(IosIapRevocationReason::DeveloperIssue)
        ));

        let currency = t.currency.expect("currency present");
        assert_eq!(currency.identifier, "USD");
        assert!(currency.is_iso_currency);

        let Ios17Specific::Available(storefront) = t.storefront else {
            panic!("storefront should be available");
        };
        assert_eq!(storefront.id, "143441");
        assert_eq!(storefront.country_code, "USA");

        assert!(matches!(
            t.reason,
            Ios17Specific::Available(IosIapTransactionReason::Purchase)
        ));
    }

    /// Swift omits `nil` rather than encoding `null`, so the iOS 16 shape has whole keys missing.
    #[test]
    fn parses_a_transaction_with_every_optional_absent() {
        let t = transaction(fixtures::TRANSACTION_MINIMAL);

        assert_eq!(t.id, 1);
        assert_eq!(t.revocation_date, None);
        assert_eq!(t.expiration_date, None);
        assert!(t.currency.is_none());
        assert!(t.revocation_reason.is_none());
        assert_eq!(t.app_account_token, None);
        assert_eq!(t.web_order_line_item_id, None);
        assert_eq!(t.subscription_group_id, None);
        // below iOS 17 these two are unavailable rather than merely empty
        assert!(matches!(t.storefront, Ios17Specific::NotAvailable));
        assert!(matches!(t.reason, Ios17Specific::NotAvailable));
        assert!(matches!(t.product_type, IosIapProductType::Consumable));
        assert!(matches!(t.environment, IosIapEnvironment::Production));
    }

    #[test]
    fn parses_products_including_subscription_info() {
        let response = serde_json::from_str::<ProductsResponseDto>(fixtures::PRODUCTS)
            .expect("swift payload should parse")
            .convert();

        let IosIapProductsResponse::Done(products) = response else {
            panic!("expected products");
        };
        assert_eq!(products.len(), 2);

        let plain = &products[0];
        assert_eq!(plain.id, "com.rustunit.zoolitaire.levelunlock");
        assert_eq!(plain.display_price, "$1.99");
        assert_eq!(plain.display_name, "Level Unlock");
        assert_eq!(plain.description, "Unlocks all levels");
        assert!((plain.price - 1.99).abs() < f64::EPSILON);
        assert!(plain.subscription.is_none());

        let sub = products[1].subscription.as_ref().expect("subscription");
        assert_eq!(sub.group_id, "group-1");
        assert!(sub.is_eligible_for_intro_offer);
        assert!(matches!(
            sub.period.unit,
            IosIapSubscriptionPeriodUnit::Month
        ));
        assert_eq!(sub.period.value, 1);
        assert_eq!(sub.state.len(), 1);
        assert!(matches!(
            sub.state[0].state,
            IosIapSubscriptionRenewalState::InGracePeriod
        ));
        assert_eq!(sub.state[0].transaction.id, 42);
    }

    #[test]
    fn maps_a_products_failure_to_an_error() {
        let response = serde_json::from_str::<ProductsResponseDto>(fixtures::PRODUCTS_ERROR)
            .expect("swift payload should parse")
            .convert();

        let IosIapProductsResponse::Error(e) = response else {
            panic!("expected an error");
        };
        assert_eq!(e, "The operation couldn't be completed.");
    }

    #[test]
    fn parses_a_transaction_list() {
        let response = serde_json::from_str::<TransactionsResponseDto>(fixtures::TRANSACTIONS)
            .expect("swift payload should parse")
            .convert();

        let IosIapTransactionResponse::Done(transactions) = response else {
            panic!("expected transactions");
        };
        assert_eq!(transactions.len(), 2);
        assert_eq!(transactions[0].id, 1);
        assert_eq!(transactions[1].id, 2000000123456789);
    }

    #[test]
    fn maps_a_cancelled_purchase_to_the_product_id() {
        let response = serde_json::from_str::<PurchaseResponseDto>(fixtures::PURCHASE_CANCELED)
            .expect("swift payload should parse")
            .convert();

        let IosIapPurchaseResponse::Canceled(id) = response else {
            panic!("expected a cancellation");
        };
        assert_eq!(id, "com.rustunit.zoolitaire.levelunlock");
    }

    /// The nested StoreKit message and the outer localized description are different strings and
    /// must not be swapped.
    #[test]
    fn keeps_the_storekit_error_message_separate_from_the_description() {
        let response =
            serde_json::from_str::<PurchaseResponseDto>(fixtures::PURCHASE_STOREKIT_ERROR)
                .expect("swift payload should parse")
                .convert();

        let IosIapPurchaseResponse::StoreKitError {
            error,
            localized_description,
        } = response
        else {
            panic!("expected a storekit error");
        };

        assert_eq!(localized_description, "outer description");
        let IosIapStoreKitError::NetworkError(inner) = error else {
            panic!("expected a network error");
        };
        assert_eq!(inner, "inner network failure");
    }

    #[test]
    fn parses_a_purchase_error() {
        let response = serde_json::from_str::<PurchaseResponseDto>(fixtures::PURCHASE_ERROR)
            .expect("swift payload should parse")
            .convert();

        let IosIapPurchaseResponse::PurchaseError {
            error,
            localized_description,
        } = response
        else {
            panic!("expected a purchase error");
        };
        assert!(matches!(error, IosIapPurchaseError::ProductUnavailable));
        assert_eq!(localized_description, "product unavailable");
    }

    #[test]
    fn parses_an_unknown_finish_response() {
        let response =
            serde_json::from_str::<TransactionFinishResponseDto>(fixtures::FINISH_UNKNOWN)
                .expect("swift payload should parse")
                .convert();

        assert!(matches!(
            response,
            IosIapTransactionFinishResponse::UnknownTransaction(99)
        ));
    }

    /// A payload the shim never sends still has to produce a response rather than panic, so that
    /// a request cannot hang forever.
    #[test]
    fn unexpected_kinds_become_errors() {
        let response = serde_json::from_str::<PurchaseResponseDto>(r#"{"kind":"from_the_future"}"#)
            .expect("payload should parse")
            .convert();

        assert!(matches!(response, IosIapPurchaseResponse::Error(_)));
    }
}
