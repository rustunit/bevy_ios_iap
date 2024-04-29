# bevy_ios_iap

**note**: this currently does not ship precompiled binaries so it will only work if you clone and integrate as a local Swift package and build the binaries for the `RustXcframework.xcframework`

## Features
* fetch detailed products
* purchase
* listen to changes on previous transactions
* fetch list of all transactions (to restore old purchases)

## TODOs
* support subscription product type
* catch exceptions in swift functions and report errors to rust
* allow access to signature for remote verification
* support offers
* support family sharing
* transaction revocation reason

## Swift-Bridge wishlist
* support derives(Clone,Debug) on shared enums
* support calling async swift from rust
* allow shared structs in `Vec`'s (Vectorizable)
