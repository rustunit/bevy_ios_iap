use std::sync::OnceLock;

use bevy_crossbeam_event::CrossbeamEventSender;

#[allow(unused_imports)]
pub use ffi::*;

use crate::plugin::IosIapEvents;
use crate::transaction::IosIapTransaction;
use crate::{
    IosIapEnvironment, IosIapProduct, IosIapProductType, IosIapPurchaseResult, IosIapStorefront,
    IosIapTransactionFinished, IosIapTransactionReason,
};

#[swift_bridge::bridge]
mod ffi {

    extern "Rust" {
        type IosIapProduct;
        type IosIapProductType;
        type IosIapPurchaseResult;
        type IosIapTransaction;
        type IosIapTransactionReason;
        type IosIapEnvironment;
        type IosIapStorefront;

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
        #[swift_bridge(associated_to = IosIapPurchaseResult)]
        fn error(e: String) -> IosIapPurchaseResult;

        #[swift_bridge(associated_to = IosIapEnvironment)]
        fn sandbox() -> IosIapEnvironment;
        #[swift_bridge(associated_to = IosIapEnvironment)]
        fn production() -> IosIapEnvironment;
        #[swift_bridge(associated_to = IosIapEnvironment)]
        fn xcode() -> IosIapEnvironment;

        #[swift_bridge(associated_to = IosIapStorefront)]
        fn storefront(id: String, country_code: String) -> IosIapStorefront;

        #[swift_bridge(associated_to = IosIapTransaction)]
        fn new_transaction(
            id: u64,
            product_id: String,
            app_bundle_id: String,
            purchase_date: u64,
            purchased_quantity: i32,
            storefront_country_code: String,
            signed_date: u64,
            is_upgraded: bool,
            product_type: IosIapProductType,
            reason: IosIapTransactionReason,
            environment: IosIapEnvironment,
            storefront: IosIapStorefront,
        ) -> IosIapTransaction;
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn add_revocation(t: &mut IosIapTransaction, date: u64);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn add_expiration(t: &mut IosIapTransaction, date: u64);

        #[swift_bridge(associated_to = IosIapTransactionReason)]
        fn renewal() -> IosIapTransactionReason;
        #[swift_bridge(associated_to = IosIapTransactionReason)]
        fn purchase() -> IosIapTransactionReason;

        type IosIapTransactionFinished;
        #[swift_bridge(associated_to = IosIapTransactionFinished)]
        fn finished(t: IosIapTransaction) -> IosIapTransactionFinished;
        #[swift_bridge(associated_to = IosIapTransactionFinished)]
        fn error(e: String) -> IosIapTransactionFinished;
        #[swift_bridge(associated_to = IosIapTransactionFinished)]
        fn unknown(id: u64) -> IosIapTransactionFinished;

        fn products_received(products: Vec<IosIapProduct>);
        fn all_transactions(transactions: Vec<IosIapTransaction>);
        fn purchase_processed(result: IosIapPurchaseResult);
        fn transaction_update(t: IosIapTransaction);
        fn transaction_finished(t: IosIapTransactionFinished);
    }

    extern "Swift" {
        pub fn ios_iap_init();
        pub fn ios_iap_products(products: Vec<String>);
        pub fn ios_iap_purchase(id: String);
        pub fn ios_iap_transactions_all();
        pub fn ios_iap_transaction_finish(id: u64);
    }
}

static SENDER: OnceLock<Option<CrossbeamEventSender<IosIapEvents>>> = OnceLock::new();

#[allow(dead_code)]
pub fn set_sender(sender: CrossbeamEventSender<IosIapEvents>) {
    while !SENDER.set(Some(sender.clone())).is_ok() {}
}

fn transaction_update(t: IosIapTransaction) {
    SENDER
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::Transaction(t));
}

fn all_transactions(transactions: Vec<IosIapTransaction>) {
    SENDER
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::AllTransactions(transactions));
}

fn transaction_finished(t: IosIapTransactionFinished) {
    SENDER
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::TransactionFinished(t));
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
