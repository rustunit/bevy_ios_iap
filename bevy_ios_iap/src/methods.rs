#![allow(unused_variables)]

#[allow(unused_imports)]
use crate::native;

pub fn get_products(products: Vec<String>) {
    #[cfg(target_os = "ios")]
    native::ios_iap_products(products);
}

pub fn purchase(id: String) {
    #[cfg(target_os = "ios")]
    native::ios_iap_purchase(id);
}

pub fn finish_transaction(id: u64) {
    #[cfg(target_os = "ios")]
    native::ios_iap_transaction_finish(id);
}

pub fn all_transactions() {
    #[cfg(target_os = "ios")]
    native::ios_iap_transactions_all();
}
