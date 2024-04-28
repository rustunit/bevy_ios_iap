mod native;
mod plugin;

pub use plugin::{IosIapEvents, IosIapPlugin};

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

pub fn get_products(products: Vec<String>) {
    #[cfg(target_os = "ios")]
    native::ios_iap_products(products);
}

pub fn purchase(id: String) {
    #[cfg(target_os = "ios")]
    native::ios_iap_purchase(id);
}
