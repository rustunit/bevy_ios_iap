# bevy_ios_iap

Provides access to iOS native StoreKit2 Swift API from inside Bevy Apps.
It uses [Swift-Bridge](https://github.com/chinedufn/swift-bridge) to auto-generate the glue code and transport datatypes.

![demo](./demo.gif)

See also [bevy_ios_notifications](https://github.com/rustunit/bevy_ios_notifications), [bevy_ios_alerts](https://github.com/rustunit/bevy_ios_alerts) & [bevy_ios_impact](https://github.com/rustunit/bevy_ios_impact)

**note**: this currently does not ship precompiled binaries so it will only work if you clone and integrate as a local Swift package and build the binaries for the `RustXcframework.xcframework`, please use `make build` for an automated process for this

## Features
* fetch detailed products
* purchase
* listen to changes in previous transactions
* fetch list of all transactions (to restore old purchases of non-consumables)

## Notes
* does not return locally un-signed/un-verified transactions

## Todo
* support subscription product type
* catch exceptions in swift functions and report errors to rust
* allow access to signature for remote verification
* support offers
* support family sharing
* transaction revocation reason

## Swift-Bridge wishlist
* how to return data from swift that rust can read? (`fn foo() -> Bar`)
* make @_cdecl funcs `public` (https://github.com/chinedufn/swift-bridge/issues/166)
* allow changing stuff to allow multiple libs using this approach (`SwiftBridgeCore.swift`, Name of `RustXcframework`, `Headers` subfolder etc.) see https://github.com/jessegrosjean/swift-cargo-problem
* support derives(Clone,Debug) on shared enums
* support calling async swift from rust
* allow shared structs in `Vec`'s (Vectorizable)
* properly add missing `import RustXcframework` when using Swift Package approach
* add `swift_bridge_build.update_package` to only copy the files over instead of generating everything (and do the above)
* best practice to offer a swift package containing prebuild binaries? (`RustXcframework`)