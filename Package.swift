// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bevy_ios_iap",
    platforms: [.iOS("16.0")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "bevy_ios_iap",
            targets: ["bevy_ios_iap"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "RustXcframework",
            // for local development:
            // path: "RustXcframework.xcframework"),
            url:
                "https://github.com/rustunit/bevy_ios_iap/releases/download/rs-0.9.1/RustXcframework.xcframework.zip",
            checksum: "4b6d1238e833522dc1e83985846f223d65603615dcdfd491c2492a9371e67cc1"),
        .target(
            name: "bevy_ios_iap",
            dependencies: ["RustXcframework"]),
        .testTarget(
            name: "bevy_ios_iapTests",
            dependencies: ["bevy_ios_iap"]),
    ]
)
