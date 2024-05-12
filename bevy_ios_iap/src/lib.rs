mod methods;
mod native;
mod plugin;
mod transaction;

pub use methods::{
    all_transactions, current_entitlements, finish_transaction, get_products, init, purchase,
};
pub use plugin::{IosIapEvents, IosIapPlugin};
pub use transaction::IosIapTransaction;

/// Expected event data in response to [`finish_transaction`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapTransactionFinished {
    /// Unknown Unfinished Transaction, maybe a concurrent process to finish it in the meantime?
    UnknownTransaction(u64),
    /// Transaction successfully finished
    Finished(IosIapTransaction),
    /// Some error occured
    Error(String),
}

impl IosIapTransactionFinished {
    fn unknown(id: u64) -> Self {
        Self::UnknownTransaction(id)
    }

    fn finished(t: IosIapTransaction) -> Self {
        Self::Finished(t)
    }
    fn error(e: String) -> Self {
        Self::Error(e)
    }
}

/// Expected event data in response to [`purchase`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapPurchaseResult {
    /// Purchase successful
    Success(IosIapTransaction),
    /// User canceled the purchase
    Canceled(String),
    /// The purchase is pending, and requires action from the customer. If the transaction completes,
    /// it's available through the TransactionObserver registered via [`init`] and lead to [`IosIapEvents::Transaction`] calls.
    Pending(String),
    /// Unknown / invalid product ID was used to trigger purchase
    Unknown(String),
    /// Error occured
    Error(String),
}

impl IosIapPurchaseResult {
    fn success(t: IosIapTransaction) -> Self {
        Self::Success(t)
    }

    fn canceled(id: String) -> Self {
        Self::Canceled(id)
    }

    fn pending(id: String) -> Self {
        Self::Pending(id)
    }

    fn unknown(id: String) -> Self {
        Self::Unknown(id)
    }

    fn error(e: String) -> Self {
        Self::Error(e)
    }
}

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
        }
    }
}
