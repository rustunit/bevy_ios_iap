// Dev-only: the fixture generator links the shim, which references the Rust callbacks. It never
// reaches StoreKit, so no-ops are enough to satisfy the linker.

#include <stdint.h>

void bevy_ios_iap_products_received(int64_t request, const char *json) {}
void bevy_ios_iap_purchase_processed(int64_t request, const char *json) {}
void bevy_ios_iap_all_transactions(int64_t request, const char *json) {}
void bevy_ios_iap_current_entitlements(int64_t request, const char *json) {}
void bevy_ios_iap_transaction_finished(int64_t request, const char *json) {}
void bevy_ios_iap_transaction_update(const char *json) {}
