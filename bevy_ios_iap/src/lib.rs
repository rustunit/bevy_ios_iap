mod methods;
mod native;
mod plugin;
mod transaction;

pub use methods::{all_transactions, finish_transaction, get_products, purchase};
pub use plugin::{IosIapEvents, IosIapPlugin};
pub use transaction::IosIapTransaction;

#[derive(Debug, Clone)]
pub enum IosIapPurchaseResult {
    Success,
    Canceled,
    Pending,
}

impl IosIapPurchaseResult {
    fn success() -> Self {
        Self::Success
    }

    fn canceled() -> Self {
        Self::Canceled
    }

    fn pending() -> Self {
        Self::Pending
    }
}

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
