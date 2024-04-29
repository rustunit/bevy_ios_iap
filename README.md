# bevy_ios_iap

**note**: this currently does not ship precompiled binaries so it will only work if you clone and integrate as a local Swift package and build the binaries for the `RustXcframework.xcframework`

## Features
* fetch detailed products
* purchase
* listen to changes on previous transactions

## TODOs
* build async API (not supported by swift-bridge yet)
* support subscriptions
* support restoring purchases of non-consumables
* catch exceptions in swift functions and report errors to rust

## Swift-Bridge wishlist
* support derives(Clone,Debug) on shared enums
* support calling async swift from rust
* allow shared structs in `Vec`'s (Vectorizable)
