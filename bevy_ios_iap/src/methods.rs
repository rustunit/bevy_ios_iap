#![allow(unused_variables)]

#[allow(unused_imports)]
use crate::native;

/// Registers for any updates on Transactions.
/// Any such update will trigger: [`IosIapEvents::Transaction`][crate::IosIapEvents::Transaction]
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3851206-updates>
pub fn init() {
    #[cfg(target_os = "ios")]
    native::ios_iap_init();
}

/// Fetch Product Details. A list of Product IDs has to be provided.
/// Expected to be confirmed with event: [`IosIapEvents::Products`][crate::IosIapEvents::Products]
///
/// See <https://developer.apple.com/documentation/storekit/product/3851116-products>
pub fn get_products(products: Vec<String>) {
    #[cfg(target_os = "ios")]
    native::ios_iap_products(products);
}

/// Trigger a purchase flow. The product ID has to be provided
/// Expected to be confirmed with event: [`IosIapEvents::Purchase`][crate::IosIapEvents::Purchase]
///
/// See <https://developer.apple.com/documentation/storekit/product/3791971-purchase>
pub fn purchase(id: String) {
    #[cfg(target_os = "ios")]
    native::ios_iap_purchase(id);
}

/// Finishes a Transaction. Identify the Transaction with an ID.
/// Apple expects us to call this only after the user got the Product granted so we can safely consider this purchase finished.
/// Until the transaction is finished iOS will keep triggering it as soon as we register the
/// TransactionObserver via the `init` call. See [`crate::init`].
///
/// Expected to be confirmed with event: [`IosIapEvents::TransactionFinished`][crate::IosIapEvents::TransactionFinished]
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3749694-finish>
pub fn finish_transaction(id: u64) {
    #[cfg(target_os = "ios")]
    native::ios_iap_transaction_finish(id);
}

/// Quoted from Apple's docs: "A sequence that emits all the transactions for the user for your app."
///
/// Unlike [`crate::current_entitlements`] this will also return unfinished Transactions. Otherwise the result is the same.
///
/// Expected to be confirmed with event: [`IosIapEvents::AllTransactions`][crate::IosIapEvents::AllTransactions]
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3851203-all>
pub fn all_transactions() {
    #[cfg(target_os = "ios")]
    native::ios_iap_transactions_all();
}

/// Quoted from Apple docs: "A sequence of the latest transactions that entitle a user to in-app purchases and subscriptions."
///
/// Ususally used for "RestorePurchases" functionality.
/// Most importantly this will only included active subscriptions and non-consumables.
/// Finished Transactions of Consumables will never appear again.
///
/// Expected to be confirmed with event: [`IosIapEvents::CurrentEntitlements`][crate::IosIapEvents::CurrentEntitlements]
///
/// See <https://developer.apple.com/documentation/storekit/transaction/3851204-currententitlements>
pub fn current_entitlements() {
    #[cfg(target_os = "ios")]
    native::ios_iap_transactions_current_entitlements();
}
