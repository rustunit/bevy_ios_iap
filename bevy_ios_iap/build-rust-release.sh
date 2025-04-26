# build-rust.sh

#!/bin/bash

set -e

THISDIR=$(dirname $0)
cd $THISDIR

touch ./src/lib.rs
cargo build --release --target aarch64-apple-ios
cargo build --release --target x86_64-apple-ios
# TODO: enable once https://github.com/rust-lang/rust-bindgen/issues/3181 is released
# cargo build --release --target aarch64-apple-ios-sim
#
mkdir -p ./target/universal-ios/release

# TODO: add back sim target
lipo -create \
    "./target/aarch64-apple-ios/release/libbevy_ios_iap.a" \
    "./target/x86_64-apple-ios/release/libbevy_ios_iap.a" \
    -output ./target/universal-ios/release/libbevy_ios_iap.a
