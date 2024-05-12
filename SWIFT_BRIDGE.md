# Swift-Bridge wishlist

* how to return data from swift that rust can read? (`fn foo() -> Bar`)
* make @_cdecl funcs `public` (https://github.com/chinedufn/swift-bridge/issues/166)
* allow changing stuff to allow multiple libs using this approach (`SwiftBridgeCore.swift`, Name of `RustXcframework`, `Headers` subfolder etc.) see https://github.com/jessegrosjean/swift-cargo-problem
* support derives(Clone,Debug) on shared enums
* support calling async swift from rust
* allow shared structs in `Vec`'s (Vectorizable)
* properly add missing `import RustXcframework` when using Swift Package approach
* add `swift_bridge_build.update_package` to only copy the files over instead of generating everything (and do the above)
* how to get swift `Data` out? cannot figure out how to convert that into RustVec<UInt8> or anything compatible