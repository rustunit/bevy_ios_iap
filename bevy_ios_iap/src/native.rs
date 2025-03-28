use std::sync::OnceLock;

use bevy_crossbeam_event::CrossbeamEventSender;

#[allow(unused_imports)]
pub use ffi::*;

use crate::{
    plugin::{IosIapEvents, IosIapResponse},
    transaction::IosIapTransaction,
    IosIapCurrency, IosIapEnvironment, IosIapProduct, IosIapProductType, IosIapProductsResponse,
    IosIapPurchaseError, IosIapPurchaseResponse, IosIapRevocationReason, IosIapStoreKitError,
    IosIapStorefront, IosIapSubscriptionInfo, IosIapSubscriptionPeriod,
    IosIapSubscriptionPeriodUnit, IosIapSubscriptionRenewalState, IosIapSubscriptionStatus,
    IosIapTransactionFinishResponse, IosIapTransactionReason, IosIapTransactionResponse,
};

#[swift_bridge::bridge]
mod ffi {

    extern "Rust" {
        type IosIapProduct;
        type IosIapProductType;
        type IosIapPurchaseResponse;
        type IosIapPurchaseError;
        type IosIapStoreKitError;
        type IosIapTransaction;
        type IosIapTransactionReason;
        type IosIapEnvironment;
        type IosIapStorefront;
        type IosIapSubscriptionInfo;
        type IosIapSubscriptionPeriod;
        type IosIapSubscriptionPeriodUnit;
        type IosIapSubscriptionStatus;
        type IosIapSubscriptionRenewalState;
        type IosIapCurrency;
        type IosIapRevocationReason;
        type IosIapProductsResponse;
        type IosIapTransactionResponse;

        #[swift_bridge(associated_to = IosIapProduct)]
        fn new(
            id: String,
            display_price: String,
            display_name: String,
            description: String,
            price: f64,
            product_type: IosIapProductType,
        ) -> IosIapProduct;
        #[swift_bridge(associated_to = IosIapProduct)]
        fn subscription(t: &mut IosIapProduct, info: IosIapSubscriptionInfo);

        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_consumable(non: bool) -> IosIapProductType;
        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_non_renewable() -> IosIapProductType;
        #[swift_bridge(associated_to = IosIapProductType)]
        fn new_auto_renewable() -> IosIapProductType;

        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn success(t: IosIapTransaction) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn canceled(id: String) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn pending(id: String) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn unknown(id: String) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn error(e: String) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn purchase_error(
            error: IosIapPurchaseError,
            localized_description: String,
        ) -> IosIapPurchaseResponse;
        #[swift_bridge(associated_to = IosIapPurchaseResponse)]
        fn storekit_error(
            error: IosIapStoreKitError,
            localized_description: String,
        ) -> IosIapPurchaseResponse;

        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn invalid_quantity() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn product_unavailable() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn purchase_not_allowed() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn ineligible_for_offer() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn invalid_offer_identifier() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn invalid_offer_price() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn invalid_offer_signature() -> IosIapPurchaseError;
        #[swift_bridge(associated_to = IosIapPurchaseError)]
        fn missing_offer_parameters() -> IosIapPurchaseError;

        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn unknown() -> IosIapStoreKitError;
        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn user_cancelled() -> IosIapStoreKitError;
        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn network_error(e: String) -> IosIapStoreKitError;
        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn system_error(e: String) -> IosIapStoreKitError;
        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn not_available_in_storefront() -> IosIapStoreKitError;
        #[swift_bridge(associated_to = IosIapStoreKitError)]
        fn not_entitled() -> IosIapStoreKitError;

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
            original_purchase_date: u64,
            purchased_quantity: i32,
            storefront_country_code: String,
            signed_date: u64,
            is_upgraded: bool,
            original_id: u64,
            json_representation: String,
            product_type: IosIapProductType,
            environment: IosIapEnvironment,
        ) -> IosIapTransaction;
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn add_revocation(t: &mut IosIapTransaction, date: u64);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn add_expiration(t: &mut IosIapTransaction, date: u64);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn add_currency(t: &mut IosIapTransaction, currency: IosIapCurrency);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn revocation_reason(t: &mut IosIapTransaction, reason: IosIapRevocationReason);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn web_order_line_item_id(t: &mut IosIapTransaction, id: String);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn subscription_group_id(t: &mut IosIapTransaction, id: String);
        #[swift_bridge(associated_to = IosIapTransaction)]
        fn app_account_token(t: &mut IosIapTransaction, uuid: String);

        #[swift_bridge(associated_to = IosIapTransactionReason)]
        fn renewal() -> IosIapTransactionReason;
        #[swift_bridge(associated_to = IosIapTransactionReason)]
        fn purchase() -> IosIapTransactionReason;

        type IosIapTransactionFinishResponse;
        #[swift_bridge(associated_to = IosIapTransactionFinishResponse)]
        fn finished(t: IosIapTransaction) -> IosIapTransactionFinishResponse;
        #[swift_bridge(associated_to = IosIapTransactionFinishResponse)]
        fn error(e: String) -> IosIapTransactionFinishResponse;
        #[swift_bridge(associated_to = IosIapTransactionFinishResponse)]
        fn unknown(id: u64) -> IosIapTransactionFinishResponse;

        #[swift_bridge(associated_to = IosIapSubscriptionInfo)]
        fn new(
            group_id: String,
            period: IosIapSubscriptionPeriod,
            is_eligible_for_intro_offer: bool,
            state: Vec<IosIapSubscriptionStatus>,
        ) -> IosIapSubscriptionInfo;

        #[swift_bridge(associated_to = IosIapSubscriptionPeriod)]
        fn new(unit: IosIapSubscriptionPeriodUnit, value: i32) -> IosIapSubscriptionPeriod;

        #[swift_bridge(associated_to = IosIapSubscriptionPeriodUnit)]
        fn day() -> IosIapSubscriptionPeriodUnit;
        #[swift_bridge(associated_to = IosIapSubscriptionPeriodUnit)]
        fn week() -> IosIapSubscriptionPeriodUnit;
        #[swift_bridge(associated_to = IosIapSubscriptionPeriodUnit)]
        fn month() -> IosIapSubscriptionPeriodUnit;
        #[swift_bridge(associated_to = IosIapSubscriptionPeriodUnit)]
        fn year() -> IosIapSubscriptionPeriodUnit;

        #[swift_bridge(associated_to = IosIapSubscriptionRenewalState)]
        fn subscribed() -> IosIapSubscriptionRenewalState;
        #[swift_bridge(associated_to = IosIapSubscriptionRenewalState)]
        fn expired() -> IosIapSubscriptionRenewalState;
        #[swift_bridge(associated_to = IosIapSubscriptionRenewalState)]
        fn in_billing_retry_period() -> IosIapSubscriptionRenewalState;
        #[swift_bridge(associated_to = IosIapSubscriptionRenewalState)]
        fn in_grace_period() -> IosIapSubscriptionRenewalState;
        #[swift_bridge(associated_to = IosIapSubscriptionRenewalState)]
        fn revoked() -> IosIapSubscriptionRenewalState;

        #[swift_bridge(associated_to = IosIapSubscriptionStatus)]
        fn new(
            state: IosIapSubscriptionRenewalState,
            transaction: IosIapTransaction,
        ) -> IosIapSubscriptionStatus;

        #[swift_bridge(associated_to = IosIapCurrency)]
        fn new(identifier: String, is_iso_currency: bool) -> IosIapCurrency;

        #[swift_bridge(associated_to = IosIapRevocationReason)]
        fn developer_issue() -> IosIapRevocationReason;
        #[swift_bridge(associated_to = IosIapRevocationReason)]
        fn other() -> IosIapRevocationReason;

        #[swift_bridge(associated_to = IosIapProductsResponse)]
        fn done(items: Vec<IosIapProduct>) -> IosIapProductsResponse;
        #[swift_bridge(associated_to = IosIapProductsResponse)]
        fn error(error: String) -> IosIapProductsResponse;

        #[swift_bridge(associated_to = IosIapTransactionResponse)]
        fn done(items: Vec<IosIapTransaction>) -> IosIapTransactionResponse;
        #[swift_bridge(associated_to = IosIapTransactionResponse)]
        fn error(error: String) -> IosIapTransactionResponse;

        //

        fn products_received(request: i64, response: IosIapProductsResponse);
        fn all_transactions(request: i64, response: IosIapTransactionResponse);
        fn current_entitlements(request: i64, response: IosIapTransactionResponse);
        fn purchase_processed(request: i64, result: IosIapPurchaseResponse);
        fn transaction_update(t: IosIapTransaction);
        fn transaction_finished(request: i64, t: IosIapTransactionFinishResponse);
    }

    extern "Swift" {
        pub fn ios_iap_init();
        pub fn ios_iap_products(request: i64, products: Vec<String>);
        pub fn ios_iap_purchase(request: i64, id: String);
        pub fn ios_iap_transactions_all(request: i64);
        pub fn ios_iap_transactions_current_entitlements(request: i64);
        pub fn ios_iap_transaction_finish(request: i64, transaction_id: u64);
    }
}

static SENDER_EVENTS: OnceLock<Option<CrossbeamEventSender<IosIapEvents>>> = OnceLock::new();
static SENDER_RESPONSE: OnceLock<Option<CrossbeamEventSender<IosIapResponse>>> = OnceLock::new();

#[allow(dead_code)]
pub fn set_sender_events(sender: CrossbeamEventSender<IosIapEvents>) {
    while !SENDER_EVENTS.set(Some(sender.clone())).is_ok() {}
}

#[allow(dead_code)]
pub fn set_sender_response(sender: CrossbeamEventSender<IosIapResponse>) {
    while !SENDER_RESPONSE.set(Some(sender.clone())).is_ok() {}
}

fn transaction_update(t: IosIapTransaction) {
    SENDER_EVENTS
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapEvents::TransactionUpdate(t));
}

fn all_transactions(request: i64, response: IosIapTransactionResponse) {
    SENDER_RESPONSE
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapResponse::AllTransactions((request, response)));
}

fn current_entitlements(request: i64, response: IosIapTransactionResponse) {
    SENDER_RESPONSE
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapResponse::CurrentEntitlements((request, response)));
}

fn transaction_finished(request: i64, response: IosIapTransactionFinishResponse) {
    SENDER_RESPONSE
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapResponse::TransactionFinished((request, response)));
}

fn products_received(request: i64, response: IosIapProductsResponse) {
    SENDER_RESPONSE
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapResponse::Products((request, response)));
}

fn purchase_processed(request: i64, result: IosIapPurchaseResponse) {
    // bevy_log::info!("purchase_processed: {:?}", result as u8);

    SENDER_RESPONSE
        .get()
        .unwrap()
        .as_ref()
        .unwrap()
        .send(IosIapResponse::Purchase((request, result)));
}
