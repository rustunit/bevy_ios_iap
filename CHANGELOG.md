# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [0.7.0] - 2025-04-26

### Fixed
* upgrade to bevy `0.16`
* temporarily disabled ios-sim support until rust-bindgen [releases](https://github.com/rust-lang/rust-bindgen/issues/3181)

## [0.6.0] - 2025-03-30

### Changed
* make `Transaction` `reason` and `storefront` available only ios `17.0` or up
* introduce `Ios17Specific` Option-like that forces users to handle the fact that these values are only available on iOS 17 or up
* make package iOS `16.0` compatible
* remove `currency_code` as it was deprecated in iOS `16.0`

## [0.5.2] - 2025-01-11

### Added
* add `IosIapPurchaseError` and `IosIapStoreKitError` to `IosIapPurchaseResponse` to provide programmatic error handling

## [0.5.1] - 2024-12-02

### Changed
* make `BevyIosIap` requests more typesafe, so you cannot assign a observer that does not match the response type

## [0.5.0] - 2024-12-01

### Fixed
* upgrade to bevy `0.15`

## [0.4.2] - 2024-12-01

### Fixed
* fixed broken observer api because we listened to the wrong event type

## [0.4.0] - 2024-11-27

### Changed
* support subscriptions
* new `BevyIosIap` SystemParam providing observer based API
* new fields in IosIapTransaction: `original_id`, `original_purchase_date`, `json_representation`, `currency`, `currency_code`, `revocation_reason`, `app_account_token`, `web_order_line_item_id`, `subscription_group_id`
* all calls now do proper error handling
* all calls take a request id and return it with the response used for `BevyIosIap`
* `IosIapEvents::Transaction` is not `IosIapEvents::TransactionUpdate`
* renamed `IosIapTransactionFinished` -> `IosIapTransactionFinishResponse`
* renamed `IosIapPurchaseResult` -> `IosIapPurchaseResponse`
* renamed `IosIapEvents` in `IosIapResponse` and moved `TransactionUpdate` into a new `IosIapEvents` to signify the difference between a pro-active event sent or a response to a previous request

## [0.3.0] - 2024-07-12

### Changed
* update to bevy `0.14`

## [0.2.1] - 2024-05-12

### Added
* proper rustdoc and readme with example

## [0.2.0] - 2024-05-09

### Changed
* new method `current_entitlements` that will response via `IosIapEvents::CurrentEntitlements` (see [apple docs](https://developer.apple.com/documentation/storekit/transaction/3851204-currententitlements))
* `IosIapPurchaseResult::Success` now contains the `IosIapTransaction` of the purchase
* `IosIapPurchaseResult::Pending` and `IosIapPurchaseResult::Cancel` return the Product ID used for `purchase`

### Fixes
* `IosIapTransaction.app_bundle_id` was also returing the product ID

## [0.1.2] - 2024-05-06

*note:* the crate release matches the commit tagged with the `ru-` prefix because we release the swift package after the crate due to its dependency on each other

### Added
* `IosIapPurchaseResult` can be `Unknown` if an invalid product ID is used for a purchase ([#3](https://github.com/rustunit/bevy_ios_iap/issues/3))
