pub use ffi::*;

#[derive(Debug)]
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

#[derive(Debug)]
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

#[swift_bridge::bridge]
mod ffi {

    extern "Rust" {
        type IosIapProduct;
        type IosIapProductType;

        #[swift_bridge(associated_to = IosIapProduct)]
        fn new(
            id: String,
            display_price: String,
            display_name: String,
            description: String,
            price: f64,
            product_type: IosIapProductType,
        ) -> IosIapProduct;

        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_consumable(non: bool) -> IosIapProductType;
        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_non_renewable() -> IosIapProductType;
        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_auto_renewable() -> IosIapProductType;

        fn products_received(products: Vec<IosIapProduct>);
    }

    extern "Swift" {

        pub fn bevy_ios_iap_swift_init(foo: String, products: Vec<String>);
        pub fn ios_iap_purchase(id: String);
        // async fn bevy_ios_iap_swift_get_products(products: Vec<String>) -> Vec<Product>;
    }
}

fn products_received(products: Vec<IosIapProduct>) {
    bevy_log::info!("items: {:?}", products.len());
    for p in products {
        bevy_log::info!("product: {p:?}");
    }
}
