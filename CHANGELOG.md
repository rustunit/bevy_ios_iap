# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

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