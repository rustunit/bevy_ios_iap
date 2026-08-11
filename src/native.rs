//! The iOS boundary: entry points into the Swift StoreKit 2 shim and the callbacks it calls back
//! into. The payloads themselves are described by [`crate::wire`].
//!
//! StoreKit does its work on arbitrary threads, so results are pushed into the
//! `bevy_channel_message` channels and picked up by the Bevy schedule from there.

use std::ffi::{CStr, CString, c_char};
use std::sync::OnceLock;

use bevy_channel_message::ChannelMessageSender;
use serde::Deserialize;

use crate::{
    IosIapProductsResponse, IosIapPurchaseResponse, IosIapTransactionFinishResponse,
    IosIapTransactionResponse,
    plugin::{IosIapEvents, IosIapResponse},
    wire::{
        ProductsResponseDto, PurchaseResponseDto, TransactionDto, TransactionFinishResponseDto,
        TransactionsResponseDto,
    },
};

// Implemented in `swift/BevyIosIap.swift`.
unsafe extern "C" {
    fn bevy_ios_iap_swift_init();
    fn bevy_ios_iap_swift_products(request: i64, ids_json: *const c_char);
    fn bevy_ios_iap_swift_purchase(request: i64, product_id: *const c_char);
    fn bevy_ios_iap_swift_transactions_all(request: i64);
    fn bevy_ios_iap_swift_transactions_current_entitlements(request: i64);
    fn bevy_ios_iap_swift_transaction_finish(request: i64, transaction_id: u64);
}

// MARK: - senders

static SENDER_EVENTS: OnceLock<ChannelMessageSender<IosIapEvents>> = OnceLock::new();
static SENDER_RESPONSE: OnceLock<ChannelMessageSender<IosIapResponse>> = OnceLock::new();

pub fn set_sender_events(sender: ChannelMessageSender<IosIapEvents>) {
    let _ = SENDER_EVENTS.set(sender);
}

pub fn set_sender_response(sender: ChannelMessageSender<IosIapResponse>) {
    let _ = SENDER_RESPONSE.set(sender);
}

/// StoreKit can call back before the plugin was built; dropping the response is the only option,
/// since unwinding out of the Swift call would be undefined behavior.
fn send_event(msg: IosIapEvents) {
    let Some(sender) = SENDER_EVENTS.get() else {
        bevy_log::warn!("iap event dropped: plugin not initialized");
        return;
    };
    sender.send(msg);
}

fn send_response(msg: IosIapResponse) {
    let Some(sender) = SENDER_RESPONSE.get() else {
        bevy_log::warn!("iap response dropped: plugin not initialized");
        return;
    };
    sender.send(msg);
}

// MARK: - calls into Swift

pub fn ios_iap_init() {
    // SAFETY: takes no arguments; the shim guards against registering a second observer.
    unsafe { bevy_ios_iap_swift_init() };
}

pub fn ios_iap_products(request: i64, products: Vec<String>) {
    let ids = match serde_json::to_string(&products) {
        Ok(ids) => c_string(ids),
        // product ids are plain strings, so this cannot realistically happen
        Err(e) => {
            send_response(IosIapResponse::Products((
                request,
                IosIapProductsResponse::error(format!("iap: could not encode product ids: {e}")),
            )));
            return;
        }
    };

    // SAFETY: the shim copies the string before it returns.
    unsafe { bevy_ios_iap_swift_products(request, ids.as_ptr()) };
}

pub fn ios_iap_purchase(request: i64, id: String) {
    let id = c_string(id);
    // SAFETY: the shim copies the string before it returns.
    unsafe { bevy_ios_iap_swift_purchase(request, id.as_ptr()) };
}

pub fn ios_iap_transactions_all(request: i64) {
    // SAFETY: plain scalar argument.
    unsafe { bevy_ios_iap_swift_transactions_all(request) };
}

pub fn ios_iap_transactions_current_entitlements(request: i64) {
    // SAFETY: plain scalar argument.
    unsafe { bevy_ios_iap_swift_transactions_current_entitlements(request) };
}

pub fn ios_iap_transaction_finish(request: i64, transaction_id: u64) {
    // SAFETY: plain scalar arguments.
    unsafe { bevy_ios_iap_swift_transaction_finish(request, transaction_id) };
}

/// Product ids come from the app and could contain an interior NUL. Truncating there beats
/// refusing the request outright - StoreKit will simply report the id as unknown.
fn c_string(value: String) -> CString {
    match CString::new(value.as_bytes()) {
        Ok(value) => value,
        Err(e) => {
            bevy_log::warn!("iap: string contained a NUL byte and was truncated");
            let truncated = &value.as_bytes()[..e.nul_position()];
            CString::new(truncated).unwrap_or_default()
        }
    }
}

// MARK: - callbacks from Swift

/// # Safety
/// `json` must be a NUL-terminated UTF-8 string valid for the duration of the call.
unsafe fn parse<T: for<'de> Deserialize<'de>>(json: *const c_char) -> Result<T, String> {
    if json.is_null() {
        return Err("iap: received a null payload".into());
    }

    // SAFETY: the caller guarantees a valid NUL-terminated string.
    let raw = unsafe { CStr::from_ptr(json) };
    let raw = raw
        .to_str()
        .map_err(|e| format!("iap: invalid utf8: {e}"))?;

    serde_json::from_str(raw).map_err(|e| format!("iap: could not parse response: {e}"))
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_products_received(request: i64, json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    let response = match unsafe { parse::<ProductsResponseDto>(json) } {
        Ok(dto) => dto.convert(),
        Err(e) => IosIapProductsResponse::error(e),
    };

    send_response(IosIapResponse::Products((request, response)));
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_purchase_processed(request: i64, json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    let response = match unsafe { parse::<PurchaseResponseDto>(json) } {
        Ok(dto) => dto.convert(),
        Err(e) => IosIapPurchaseResponse::error(e),
    };

    send_response(IosIapResponse::Purchase((request, response)));
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_all_transactions(request: i64, json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    let response = match unsafe { parse::<TransactionsResponseDto>(json) } {
        Ok(dto) => dto.convert(),
        Err(e) => IosIapTransactionResponse::error(e),
    };

    send_response(IosIapResponse::AllTransactions((request, response)));
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_current_entitlements(request: i64, json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    let response = match unsafe { parse::<TransactionsResponseDto>(json) } {
        Ok(dto) => dto.convert(),
        Err(e) => IosIapTransactionResponse::error(e),
    };

    send_response(IosIapResponse::CurrentEntitlements((request, response)));
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_transaction_finished(request: i64, json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    let response = match unsafe { parse::<TransactionFinishResponseDto>(json) } {
        Ok(dto) => dto.convert(),
        Err(e) => IosIapTransactionFinishResponse::error(e),
    };

    send_response(IosIapResponse::TransactionFinished((request, response)));
}

#[unsafe(no_mangle)]
extern "C" fn bevy_ios_iap_transaction_update(json: *const c_char) {
    // SAFETY: the shim passes a NUL-terminated UTF-8 payload.
    match unsafe { parse::<TransactionDto>(json) } {
        Ok(dto) => send_event(IosIapEvents::TransactionUpdate(dto.convert())),
        // unlike the request-based callbacks this is not a response to anything, so a broken
        // payload has nobody to report to
        Err(e) => bevy_log::error!("{e}"),
    }
}
