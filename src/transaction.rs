use crate::{
    IosIapCurrency, IosIapEnvironment, IosIapProductType, IosIapRevocationReason, IosIapStorefront,
    IosIapTransactionReason,
};

/// Marks an iOS 17 version dependant value. If it is set then the device supports minimum iOS 17.
/// Not using `Option` here to be explicit about the cause for a missing value and to handle it with caution.
#[derive(Debug, Clone, Copy)]
pub enum Ios17Specific<T> {
    /// The value is available on iOS 17.0 and later.
    Available(T),
    /// The value is not available on iOS 17.0 and later.
    NotAvailable,
}

/// Representation of a Transaction.
/// Mirrors the Transcation type in Apple's StoreKit2 closely.
/// See official docs for more details on the individual fields.
///
/// See <https://developer.apple.com/documentation/storekit/transaction>
#[derive(Debug, Clone)]
pub struct IosIapTransaction {
    pub id: u64,
    pub original_id: u64,
    pub product_id: String,
    pub app_bundle_id: String,
    pub purchase_date: u64,
    pub original_purchase_date: u64,
    pub revocation_date: Option<u64>,
    pub expiration_date: Option<u64>,
    pub purchased_quantity: i32,
    pub storefront_country_code: String,
    pub signed_date: u64,
    pub is_upgraded: bool,
    pub json_representation: String,
    pub product_type: IosIapProductType,
    pub storefront: Ios17Specific<IosIapStorefront>,
    pub reason: Ios17Specific<IosIapTransactionReason>,
    pub environment: IosIapEnvironment,
    pub currency: Option<IosIapCurrency>,
    pub revocation_reason: Option<IosIapRevocationReason>,
    /// representing a UUID
    pub app_account_token: Option<String>,
    pub web_order_line_item_id: Option<String>,
    pub subscription_group_id: Option<String>,
    //
    // TODO:
    //pub deviceVerification
    //pub deviceVerificationNonce

    // TODO: support family sharing
    //pub ownershipType

    // TODO: offer support
    //pub offer
    //pub offerType
    //pub offerID
}

impl IosIapTransaction {
    #[allow(clippy::too_many_arguments)]
    pub fn new_transaction(
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
    ) -> Self {
        Self {
            id,
            product_id,
            app_bundle_id,
            purchase_date,
            original_purchase_date,
            purchased_quantity,
            storefront_country_code,
            signed_date,
            app_account_token: None,
            json_representation,
            product_type,
            revocation_date: None,
            expiration_date: None,
            is_upgraded,
            environment,
            currency: None,
            original_id,
            revocation_reason: None,
            subscription_group_id: None,
            web_order_line_item_id: None,
            storefront: Ios17Specific::NotAvailable,
            reason: Ios17Specific::NotAvailable,
        }
    }

    pub fn add_storefront(t: &mut Self, store: IosIapStorefront) {
        t.storefront = Ios17Specific::Available(store);
    }

    pub fn add_reason(t: &mut Self, reason: IosIapTransactionReason) {
        t.reason = Ios17Specific::Available(reason);
    }

    pub fn add_revocation(t: &mut Self, date: u64) {
        t.revocation_date = Some(date);
    }

    pub fn add_expiration(t: &mut Self, date: u64) {
        t.expiration_date = Some(date);
    }

    pub fn add_currency(t: &mut Self, currency: IosIapCurrency) {
        t.currency = Some(currency);
    }

    pub fn revocation_reason(t: &mut Self, reason: IosIapRevocationReason) {
        t.revocation_reason = Some(reason);
    }

    pub fn web_order_line_item_id(t: &mut Self, id: String) {
        t.web_order_line_item_id = Some(id);
    }

    pub fn subscription_group_id(t: &mut Self, id: String) {
        t.subscription_group_id = Some(id);
    }

    pub fn app_account_token(t: &mut Self, uuid: String) {
        t.app_account_token = Some(uuid);
    }
}
