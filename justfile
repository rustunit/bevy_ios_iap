check:
	cd ./bevy_ios_iap/ && just check

build-rust-release:
	./bevy_ios_iap/build-rust-release.sh

build-rust:
	./bevy_ios_iap/build-rust.sh

copy-generated:
	sed -i '' 's/func __swift_bridge__/public func __swift_bridge__/g' bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.swift
	echo "import RustXcframework "|cat - ./bevy_ios_iap/generated/SwiftBridgeCore.swift > /tmp/out && mv /tmp/out ./bevy_ios_iap/generated/SwiftBridgeCore.swift
	echo "import RustXcframework "|cat - ./bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.swift > /tmp/out && mv /tmp/out ./bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.swift
	cp ./bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.h ./RustXcframework.xcframework/ios-arm64/Headers/
	cp ./bevy_ios_iap/generated/SwiftBridgeCore.h ./RustXcframework.xcframework/ios-arm64/Headers/
	cp ./bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.h ./RustXcframework.xcframework/ios-arm64_x86_64-simulator/Headers/
	cp ./bevy_ios_iap/generated/SwiftBridgeCore.h ./RustXcframework.xcframework/ios-arm64_x86_64-simulator/Headers/
	cp ./bevy_ios_iap/generated/bevy_ios_iap/bevy_ios_iap.swift ./Sources/bevy_ios_iap/
	cp ./bevy_ios_iap/generated/SwiftBridgeCore.swift ./Sources/bevy_ios_iap/

build: build-rust copy-generated
	cp ./bevy_ios_iap/target/universal-ios/debug/libbevy_ios_iap.a ./RustXcframework.xcframework/ios-arm64_x86_64-simulator/
	cp ./bevy_ios_iap/target/aarch64-apple-ios/debug/libbevy_ios_iap.a ./RustXcframework.xcframework/ios-arm64/

build-release: build-rust-release copy-generated
	cp ./bevy_ios_iap/target/universal-ios/release/libbevy_ios_iap.a ./RustXcframework.xcframework/ios-arm64_x86_64-simulator/
	cp ./bevy_ios_iap/target/aarch64-apple-ios/release/libbevy_ios_iap.a ./RustXcframework.xcframework/ios-arm64/
	ls -lisah ./RustXcframework.xcframework/ios-arm64/
	ls -lisah ./RustXcframework.xcframework/ios-arm64_x86_64-simulator

zip: build-release
	zip -r RustXcframework.xcframework.zip ./RustXcframework.xcframework/
	ls -lisah RustXcframework.xcframework.zip
	shasum -a 256 RustXcframework.xcframework.zip
	shasum -a 256 RustXcframework.xcframework.zip > RustXcframework.xcframework.sha256.txt

publish:
	cd bevy_ios_iap && cargo publish --no-verify
