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

/// > The transaction history includes consumable in-app purchases
/// > that the app hasn’t finished by calling finish(). It doesn’t
/// > include finished consumable products or finished non-renewing
/// > subscriptions, repurchased non-consumable products or subscriptions,
/// > or restored purchases.
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3851203-all>
pub fn all_transactions() {
    #[cfg(target_os = "ios")]
    native::ios_iap_transactions_all();
}
