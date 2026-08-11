# bevy_ios_iap

[![crates.io][sh_crates]][lk_crates]
[![docs.rs][sh_docs]][lk_docs]
[![discord][sh_discord]][lk_discord]

[sh_crates]: https://img.shields.io/crates/v/bevy_ios_iap.svg
[lk_crates]: https://crates.io/crates/bevy_ios_iap
[sh_docs]: https://img.shields.io/docsrs/bevy_ios_iap
[lk_docs]: https://docs.rs/bevy_ios_iap/latest/bevy_ios_iap/
[sh_discord]: https://img.shields.io/discord/1176858176897953872?label=discord&color=5561E6
[lk_discord]: https://discord.gg/rQNeEnMhus

Provides access to the iOS native StoreKit 2 API from inside Bevy Apps.

No Swift package and no XCode setup required: the crate carries a small Swift shim that `build.rs`
compiles and links for you, so `cargo add` is all it takes.

![demo](./assets/demo.gif)

> Demo from our game using this crate: [zoolitaire.com](https://zoolitaire.com)

## Features
* fetch products
* purchase products
* listen to changes in transaction states
* fetch list of all transactions (to restore old purchases of non-consumables)
* supports subscriptions
* convenient observer based API
* egui based debug ui crate see [bevy_ios_iap_egui folder](./bevy_ios_iap_egui/README.md)

## Notes
* does not return locally un-signed/un-verified transactions

## Todo
* allow access to signature for remote verification
* support offers
* support family sharing

## Instructions

1. Add Rust dependency
2. Setup Plugin

**Note:** you still have to configure your purchases in App Store Connect like for any other iOS
app. This guide does not focus on that, as it is the same no matter what engine you use.

### 1. Add Rust dependency

```
cargo add bevy_ios_iap
```

Building for iOS requires the XCode toolchain (`xcrun`, `swiftc`), which any iOS project has
anyway. `StoreKit` and the Swift shim are linked automatically - no XCode project changes needed.

The shim is built against iOS 16 by default. Set `IPHONEOS_DEPLOYMENT_TARGET` to raise it, and
make sure it matches what the rest of your app is built with:

```
IPHONEOS_DEPLOYMENT_TARGET=16.0 cargo build --target aarch64-apple-ios
```

### 2. Setup Plugin

Initialize Bevy Plugin:

```rust
// request initialisation right on startup
app.add_plugins(IosIapPlugin::new(true));
```

```rust
fn bevy_system(mut iap: BevyIosIap) {
    // If you set the plugin to manual init, this will register the
    // TranscactionObserver to listen to updates to any Transactions and trigger
    // `IosIapEvents::Transaction` accordingly.
    // Note: this will require the user to be logged in into their apple-id and popup a login dialog if not
    bevy_ios_iap::init();

    // request product details, product IDs have to be explicitly provided
    iap.products(vec!["com.rustunit.zoolitaire.levelunlock".into()])
        .on_response(|trigger: On<Products>| match &trigger.event().0 {
            IosIapProductsResponse::Done(products) => {
                info!("products loaded: {}", products.len());

                for p in products {
                    info!("product: {:?}", p);
                }
            }
            IosIapProductsResponse::Error(e) => error!("error fetching products: {e}"),
        });

    // trigger a product purchase for a specific product ID
    iap.purchase("com.rustunit.zoolitaire.levelunlock".into())
        .on_response(|trigger: On<Purchase>|{
            match &trigger.event().0 {
                IosIapPurchaseResponse::Success(t) => {
                    info!("just purchased: '{}' {}", t.product_id, t.id);

                    iap.finish_transaction(t.id).on_response(on_finish_transaction);
                }
                _ => {}
            }
        });

    // request to restore active subscriptions and non-consumables
    iap.current_entitlements()
        .on_response(|trigger: On<CurrentEntitlements>|{
            info!("current entitlements: {}", trigger.event());
        });
}
```

Process Response Events from iOS back to us in Rust:

```rust
fn process_iap_events(
    mut events: EventReader<IosIapEvents>,
) {
    for e in events.read() {
        match e {
            // this is triggered when a transaction verification state changes during the runtime of the app
            IosIapEvents::TransactionUpdate(_) => todo!(),
        }
    }
}
```

## Local development

* `just check` runs the checks, lints and tests for both crates
* `just swift-fixtures` regenerates `tests/fixtures/` using the shim's own encoder - run it after
  changing any DTO in [`swift/BevyIosIap.swift`](./swift/BevyIosIap.swift), otherwise the tests in
  [`src/wire.rs`](./src/wire.rs) that guard the Rust/Swift JSON contract will fail

## Our Other Crates

- [bevy_debug_log](https://github.com/rustunit/bevy_debug_log)
- [bevy_device_lang](https://github.com/rustunit/bevy_device_lang)
- [bevy_web_popups](https://github.com/rustunit/bevy_web_popups)
- [bevy_libgdx_atlas](https://github.com/rustunit/bevy_libgdx_atlas)
- [bevy_ios_review](https://github.com/rustunit/bevy_ios_review)
- [bevy_ios_gamecenter](https://github.com/rustunit/bevy_ios_gamecenter)
- [bevy_ios_alerts](https://github.com/rustunit/bevy_ios_alerts)
- [bevy_ios_notifications](https://github.com/rustunit/bevy_ios_notifications)
- [bevy_ios_impact](https://github.com/rustunit/bevy_ios_impact)
- [bevy_ios_safearea](https://github.com/rustunit/bevy_ios_safearea)

## Bevy version support

|bevy|crate|
|---|---|
|0.19|0.10,0.11,main|
|0.18|0.9|
|0.17|0.8|
|0.16|0.6,0.7|
|0.15|0.5|
|0.14|0.3,0.4|
|0.13|0.2|

# License

All code in this repository is dual-licensed under either:

- MIT License (LICENSE-MIT or http://opensource.org/licenses/MIT)
- Apache License, Version 2.0 (LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0)

at your option. This means you can select the license you prefer.

## Your contributions
Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.
