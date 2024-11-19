mod methods;
mod native;
mod plugin;
mod request;
mod response;
mod transaction;

pub use methods::{
    all_transactions, current_entitlements, finish_transaction, get_products, init, purchase,
};
pub use plugin::{IosIapEvents, IosIapPlugin, IosIapResponse};
pub use request::{
    AllTransactions, BevyIosIap, BevyIosIapRequestBuilder, CurrentEntitlements, FinishTransaction,
    Products, Purchase,
};
pub use response::{
    IosIapProductsResponse, IosIapPurchaseResponse, IosIapTransactionFinishResponse,
    IosIapTransactionResponse,
};
pub use transaction::IosIapTransaction;

/// A cause of a purchase transaction, indicating whether it’s a customer’s purchase or
/// an auto-renewable subscription renewal that the system initiates.
///
/// Part of [`IosIapTransaction`].
///
/// See <https://developer.apple.com/documentation/storekit/transaction/reason>
#[derive(Debug, Clone)]
pub enum IosIapTransactionReason {
    Renewal,
    Purchase,
}

impl IosIapTransactionReason {
    pub fn renewal() -> Self {
        Self::Renewal
    }
    pub fn purchase() -> Self {
        Self::Purchase
    }
}

/// The server environment that generates and signs the transaction.
///
/// Part of [`IosIapTransaction`].
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3963920-environment>
#[derive(Debug, Clone)]
pub enum IosIapEnvironment {
    Production,
    Sandbox,
    XCode,
}

impl IosIapEnvironment {
    pub fn production() -> Self {
        Self::Production
    }
    pub fn sandbox() -> Self {
        Self::Sandbox
    }
    pub fn xcode() -> Self {
        Self::XCode
    }
}

/// The App Store storefront associated with the transaction.
///
/// Part of [`IosIapTransaction`].
///
/// See <https://developer.apple.com/documentation/storekit/transaction/4193541-storefront>
#[derive(Debug, Clone, Default)]
pub struct IosIapStorefront {
    pub id: String,
    pub country_code: String,
}

impl IosIapStorefront {
    fn storefront(id: String, country_code: String) -> Self {
        Self { id, country_code }
    }
}

/// The type of the in-app purchase.
///
/// Part of [`IosIapTransaction`] and [`IosIapProduct`].
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3749708-producttype>
#[derive(Debug, Clone)]
pub enum IosIapProductType {
    Consumable,
    NonConsumable,
    NonRenewable,
    AutoRenewable,
}

impl IosIapProductType {
    fn new_consumable(non: bool) -> Self {
        if non {
            Self::NonConsumable
        } else {
            Self::Consumable
        }
    }

    fn new_non_renewable() -> Self {
        Self::NonRenewable
    }

    fn new_auto_renewable() -> Self {
        Self::AutoRenewable
    }
}

/// Expected event data in response to [`get_products`] method call.
///
/// See Event [`IosIapEvents`]
///
/// See <https://developer.apple.com/documentation/storekit/product>
#[derive(Debug, Clone)]
pub struct IosIapProduct {
    pub id: String,
    pub display_price: String,
    pub display_name: String,
    pub description: String,
    pub price: f64,
    pub product_type: IosIapProductType,
    pub subscription: Option<IosIapSubscriptionInfo>,
}

impl IosIapProduct {
    fn new(
        id: String,
        display_price: String,
        display_name: String,
        description: String,
        price: f64,
        product_type: IosIapProductType,
    ) -> Self {
        Self {
            id,
            display_price,
            display_name,
            description,
            price,
            product_type,
            subscription: None,
        }
    }

    fn subscription(p: &mut Self, info: IosIapSubscriptionInfo) {
        p.subscription = Some(info);
    }
}

/// Expected event data in response to [`get_products`] method call.
///
/// See [`IosIapProduct`]
///
/// See <https://developer.apple.com/documentation/storekit/product/subscriptioninfo>
#[derive(Debug, Clone)]
pub struct IosIapSubscriptionInfo {
    pub group_id: String,
    pub period: IosIapSubscriptionPeriod,
    pub is_eligible_for_intro_offer: bool,
    pub state: Vec<IosIapSubscriptionStatus>,
}

impl IosIapSubscriptionInfo {
    fn new(
        group_id: String,
        period: IosIapSubscriptionPeriod,
        is_eligible_for_intro_offer: bool,
        state: Vec<IosIapSubscriptionStatus>,
    ) -> Self {
        Self {
            group_id,
            period,
            is_eligible_for_intro_offer,
            state,
        }
    }
}

/// Used in [`IosIapSubscriptionPeriod`]
///
/// See <https://developer.apple.com/documentation/storekit/product/subscriptionperiod/unit>
#[derive(Debug, Clone)]
pub enum IosIapSubscriptionPeriodUnit {
    Day,
    Week,
    Month,
    Year,
}

impl IosIapSubscriptionPeriodUnit {
    pub fn day() -> Self {
        Self::Day
    }
    pub fn week() -> Self {
        Self::Week
    }
    pub fn month() -> Self {
        Self::Month
    }
    pub fn year() -> Self {
        Self::Year
    }
}

/// Used in [`IosIapSubscriptionInfo`]
///
/// See <https://developer.apple.com/documentation/storekit/product/subscriptionperiod>
#[derive(Debug, Clone)]
pub struct IosIapSubscriptionPeriod {
    pub unit: IosIapSubscriptionPeriodUnit,
    pub value: i32,
}

impl IosIapSubscriptionPeriod {
    pub fn new(unit: IosIapSubscriptionPeriodUnit, value: i32) -> Self {
        Self { unit, value }
    }
}

/// Used in [`IosIapSubscriptionStatus`]
///
/// See <https://developer.apple.com/documentation/storekit/product/subscriptioninfo/renewalstate>
#[derive(Debug, Clone)]
pub enum IosIapSubscriptionRenewalState {
    Subscribed,
    Expired,
    InBillingRetryPeriod,
    InGracePeriod,
    Revoked,
}

impl IosIapSubscriptionRenewalState {
    pub fn subscribed() -> Self {
        Self::Subscribed
    }
    pub fn expired() -> Self {
        Self::Expired
    }
    pub fn in_billing_retry_period() -> Self {
        Self::InBillingRetryPeriod
    }
    pub fn in_grace_period() -> Self {
        Self::InGracePeriod
    }
    pub fn revoked() -> Self {
        Self::Revoked
    }
}

/// Used in [`IosIapSubscriptionInfo`]
///
/// See <https://developer.apple.com/documentation/storekit/product/subscriptioninfo/status>
#[derive(Debug, Clone)]
pub struct IosIapSubscriptionStatus {
    pub state: IosIapSubscriptionRenewalState,
    pub transaction: IosIapTransaction,
}

impl IosIapSubscriptionStatus {
    pub fn new(state: IosIapSubscriptionRenewalState, transaction: IosIapTransaction) -> Self {
        Self { state, transaction }
    }
}

/// Used in [`IosIapTransaction`]
///
/// See <https://developer.apple.com/documentation/foundation/locale/currency>
#[derive(Debug, Clone)]
pub struct IosIapCurrency {
    pub identifier: String,
    pub is_iso_currency: bool,
}

impl IosIapCurrency {
    pub fn new(identifier: String, is_iso_currency: bool) -> Self {
        Self {
            identifier,
            is_iso_currency,
        }
    }
}

/// Used in [`IosIapTransaction`]
///
/// See <https://developer.apple.com/documentation/storekit/transaction/revocationreason>
#[derive(Debug, Clone)]
pub enum IosIapRevocationReason {
    DeveloperIssue,
    Other,
}

impl IosIapRevocationReason {
    pub fn developer_issue() -> Self {
        Self::DeveloperIssue
    }
    pub fn other() -> Self {
        Self::Other
    }
}
