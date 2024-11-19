use crate::{IosIapProduct, IosIapTransaction};

/// Expected event data in response to [`get_products`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapProductsResponse {
    Done(Vec<IosIapProduct>),
    Error(String),
}

impl IosIapProductsResponse {
    pub(crate) fn done(items: Vec<IosIapProduct>) -> Self {
        Self::Done(items)
    }
    pub(crate) fn error(e: String) -> Self {
        Self::Error(e)
    }
}

/// Expected event data in response to [`current_entitlements`] or [`all_transactions`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapTransactionResponse {
    Done(Vec<IosIapTransaction>),
    Error(String),
}

impl IosIapTransactionResponse {
    pub(crate) fn done(items: Vec<IosIapTransaction>) -> Self {
        Self::Done(items)
    }
    pub(crate) fn error(e: String) -> Self {
        Self::Error(e)
    }
}

/// Expected event data in response to [`finish_transaction`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapTransactionFinishResponse {
    /// Unknown Unfinished Transaction, maybe a concurrent process to finish it in the meantime?
    UnknownTransaction(u64),
    /// Transaction successfully finished
    Finished(IosIapTransaction),
    /// Some error occured
    Error(String),
}

impl IosIapTransactionFinishResponse {
    pub(crate) fn unknown(id: u64) -> Self {
        Self::UnknownTransaction(id)
    }

    pub(crate) fn finished(t: IosIapTransaction) -> Self {
        Self::Finished(t)
    }
    pub(crate) fn error(e: String) -> Self {
        Self::Error(e)
    }
}

/// Expected event data in response to [`purchase`] method call.
///
/// See Event [`IosIapEvents`]
#[derive(Debug, Clone)]
pub enum IosIapPurchaseResponse {
    /// Purchase successful
    Success(IosIapTransaction),
    /// User canceled the purchase
    Canceled(String),
    /// The purchase is pending, and requires action from the customer. If the transaction completes,
    /// it's available through the TransactionObserver registered via [`init`] and lead to [`IosIapEvents::Transaction`] calls.
    Pending(String),
    /// Unknown / invalid product ID was used to trigger purchase
    Unknown(String),
    /// Error occured
    Error(String),
}

impl IosIapPurchaseResponse {
    pub(crate) fn success(t: IosIapTransaction) -> Self {
        Self::Success(t)
    }

    pub(crate) fn canceled(id: String) -> Self {
        Self::Canceled(id)
    }

    pub(crate) fn pending(id: String) -> Self {
        Self::Pending(id)
    }

    pub(crate) fn unknown(id: String) -> Self {
        Self::Unknown(id)
    }

    pub(crate) fn error(e: String) -> Self {
        Self::Error(e)
    }
}
