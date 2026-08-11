check:
    cargo c
    cargo c --target=aarch64-apple-ios
    cargo c --target=aarch64-apple-ios-sim
    cargo fmt -- --check
    cargo clippy --all-targets
    cargo clippy --target=aarch64-apple-ios
    cargo clippy --target=aarch64-apple-ios-sim
    cargo test
    cd bevy_ios_iap_egui && just check

# Regenerates tests/fixtures/ with the encoder the shim actually uses, so the Rust tests keep
# checking the real wire format. Run after changing any DTO in swift/BevyIosIap.swift.
swift-fixtures:
    mkdir -p target/swift-fixtures tests/fixtures
    cat swift/BevyIosIap.swift swift/fixtures/fixtures.swift > target/swift-fixtures/main.swift
    xcrun --sdk macosx swiftc -o target/swift-fixtures/generate \
        -target $(uname -m)-apple-macos14.0 \
        -import-objc-header swift/bevy_ios_iap.h \
        target/swift-fixtures/main.swift swift/fixtures/stubs.c
    ./target/swift-fixtures/generate tests/fixtures

publish:
    cargo publish
