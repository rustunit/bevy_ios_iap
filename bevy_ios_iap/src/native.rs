use std::sync::OnceLock;

use bevy_crossbeam_event::CrossbeamEventSender;

#[allow(unused_imports)]
pub use ffi::*;

use crate::plugin::IosIapEvents;
use crate::{IosIapProduct, IosIapProductType, IosIapPurchaseResult};

#[swift_bridge::bridge]
mod ffi {

    extern "Rust" {
        type IosIapProduct;
        type IosIapProductType;
        type IosIapPurchaseResult;

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

        #[swift_bridge(associated_to = IosIapPurchaseResult)]
        fn success() -> IosIapPurchaseResult;
        #[swift_bridge(associated_to = IosIapPurchaseResult)]
        fn canceled() -> IosIapPurchaseResult;
        #[swift_bridge(associated_to = IosIapPurchaseResult)]
        fn pending() -> IosIapPurchaseResult;

        fn products_received(products: Vec<IosIapProduct>);
        fn purchase_processed(result: IosIapPurchaseResult);
    }

    extern "Swift" {

        pub fn ios_iap_products(products: Vec<String>);
        pub fn ios_iap_purchase(id: String);
    }
}

static SENDER: OnceLock<Option<CrossbeamEventSender<IosIapEvents>>> = OnceLock::new();

#[allow(dead_code)]
pub fn set_sender(sender: CrossbeamEventSender<IosIapEvents>) {
    while !SENDER.set(Some(sender.clone())).is_ok() {}
}

fn products_received(products: Vec<IosIapProduct>) {
    // bevy_log::info!("items: {:?}", products.len());
    // for p in products {
    //     bevy_log::info!("product: {p:?}");
    // }

    SENDER
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::Products(products));
}

fn purchase_processed(result: IosIapPurchaseResult) {
    // bevy_log::info!("purchase_processed: {:?}", result as u8);

    SENDER
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::Purchase(result));
}
