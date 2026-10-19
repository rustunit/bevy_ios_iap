// Callbacks implemented in Rust (see `src/native.rs`), imported into the Swift shim via
// swiftc's `-import-objc-header`. Every `json` argument is a NUL-terminated UTF-8 payload
// that Rust copies before returning, so Swift may free it right after the call.

#pragma once

#include <stdint.h>

void bevy_ios_iap_products_received(int64_t request, const char *json);
void bevy_ios_iap_purchase_processed(int64_t request, const char *json);
void bevy_ios_iap_all_transactions(int64_t request, const char *json);
void bevy_ios_iap_current_entitlements(int64_t request, const char *json);
void bevy_ios_iap_transaction_finished(int64_t request, const char *json);
void bevy_ios_iap_transaction_update(const char *json);
