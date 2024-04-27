# build-rust.sh

#!/bin/bash

set -e

THISDIR=$(dirname $0)
cd $THISDIR

touch ./src/lib.rs
cargo build --release --target aarch64-apple-ios
cargo build --release --target x86_64-apple-ios
cargo build --release --target aarch64-apple-ios-sim
mkdir -p ./target/universal-ios/release

lipo \
    ./target/aarch64-apple-ios-sim/release/libbevy_ios_iap.a \
    ./target/x86_64-apple-ios/release/libbevy_ios_iap.a -create -output \
    ./target/universal-ios/release/libbevy_ios_iap.a