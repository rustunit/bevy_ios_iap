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
#[allow(clippy::large_enum_variant)]
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
#[allow(clippy::large_enum_variant)]
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
    /// Generic error
    Error(String),
    /// Purchase error
    PurchaseError {
        error: IosIapPurchaseError,
        localized_description: String,
    },
    /// store kit error
    StoreKitError {
        error: IosIapStoreKitError,
        localized_description: String,
    },
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

    pub(crate) fn purchase_error(
        error: IosIapPurchaseError,
        localized_description: String,
    ) -> Self {
        Self::PurchaseError {
            error,
            localized_description,
        }
    }

    pub(crate) fn storekit_error(
        error: IosIapStoreKitError,
        localized_description: String,
    ) -> Self {
        Self::StoreKitError {
            error,
            localized_description,
        }
    }
}

/// Used in [`IosIapPurchaseResponse`]
///
/// See <https://developer.apple.com/documentation/storekit/product/purchaseerror>
#[derive(Debug, Clone, Copy)]
pub enum IosIapPurchaseError {
    InvalidQuantity,
    ProductUnavailable,
    PurchaseNotAllowed,
    IneligibleForOffer,
    InvalidOfferIdentifier,
    InvalidOfferPrice,
    InvalidOfferSignature,
    MissingOfferParameters,
}

impl IosIapPurchaseError {
    pub fn invalid_quantity() -> Self {
        Self::InvalidQuantity
    }

    pub fn product_unavailable() -> Self {
        Self::ProductUnavailable
    }

    pub fn purchase_not_allowed() -> Self {
        Self::PurchaseNotAllowed
    }

    pub fn ineligible_for_offer() -> Self {
        Self::IneligibleForOffer
    }

    pub fn invalid_offer_identifier() -> Self {
        Self::InvalidOfferIdentifier
    }

    pub fn invalid_offer_price() -> Self {
        Self::InvalidOfferPrice
    }

    pub fn invalid_offer_signature() -> Self {
        Self::InvalidOfferSignature
    }

    pub fn missing_offer_parameters() -> Self {
        Self::MissingOfferParameters
    }
}

/// Used in [`IosIapPurchaseResponse`]
///
/// See <https://developer.apple.com/documentation/storekit/storekiterror>
#[derive(Debug, Clone)]
pub enum IosIapStoreKitError {
    Unknown,
    UserCancelled,
    NetworkError(String),
    SystemError(String),
    NotAvailableInStorefront,
    NotEntitled,
}

impl IosIapStoreKitError {
    pub fn unknown() -> Self {
        Self::Unknown
    }

    pub fn user_cancelled() -> Self {
        Self::UserCancelled
    }

    pub fn network_error(e: String) -> Self {
        Self::NetworkError(e)
    }

    pub fn system_error(e: String) -> Self {
        Self::SystemError(e)
    }

    pub fn not_available_in_storefront() -> Self {
        Self::NotAvailableInStorefront
    }

    pub fn not_entitled() -> Self {
        Self::NotEntitled
    }
}
