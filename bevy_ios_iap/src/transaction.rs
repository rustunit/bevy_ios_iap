use crate::{IosIapEnvironment, IosIapProductType, IosIapStorefront, IosIapTransactionReason};

#[derive(Debug, Clone)]
pub struct IosIapTransaction {
    pub id: u64,
    pub product_id: String,
    pub app_bundle_id: String,
    pub purchase_date: u64,
    pub revocation_date: Option<u64>,
    pub expiration_date: Option<u64>,
    pub purchased_quantity: i32,
    pub storefront_country_code: String,
    pub signed_date: u64,
    pub is_upgraded: bool,
    pub product_type: IosIapProductType,
    pub storefront: IosIapStorefront,
    pub environment: IosIapEnvironment,
    pub reason: IosIapTransactionReason,
}

impl IosIapTransaction {
    pub fn new_transaction(
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
    ) -> Self {
        Self {
            id,
            product_id,
            app_bundle_id,
            purchase_date,
            purchased_quantity,
            storefront_country_code,
            signed_date,
            reason,
            product_type,
            revocation_date: None,
            expiration_date: None,
            is_upgraded,
            environment,
            storefront,
        }
    }

    pub fn add_revocation(t: &mut Self, date: u64) {
        t.revocation_date = Some(date);
    }

    pub fn add_expiration(t: &mut Self, date: u64) {
        t.expiration_date = Some(date);
    }
}
