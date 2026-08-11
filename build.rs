//! Compiles the StoreKit 2 Swift shim (`swift/BevyIosIap.swift`) into a static library and links
//! it into the crate, so a `cargo add` is all a Bevy app needs - no Swift package.
//!
//! Only runs for iOS targets; on every other target `src/native.rs` is cfg'd out and there is
//! nothing to build.

use std::path::{Path, PathBuf};
use std::process::Command;

/// StoreKit 2 needs iOS 15, `Transaction.environment` and `Locale.Currency` need 16.
const DEFAULT_DEPLOYMENT_TARGET: &str = "16.0";

const SWIFT_SOURCE: &str = "swift/BevyIosIap.swift";
const BRIDGE_HEADER: &str = "swift/bevy_ios_iap.h";
const LIB_NAME: &str = "bevy_ios_iap_swift";

fn main() {
    println!("cargo:rerun-if-changed={SWIFT_SOURCE}");
    println!("cargo:rerun-if-changed={BRIDGE_HEADER}");
    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-env-changed=IPHONEOS_DEPLOYMENT_TARGET");

    // docs.rs builds for macOS and has no Xcode toolchain.
    if std::env::var_os("DOCS_RS").is_some() {
        return;
    }

    let target = std::env::var("TARGET").expect("cargo sets TARGET");
    let Some((platform_suffix, sdk, clang_rt)) = ios_platform(&target) else {
        return;
    };

    let arch = match std::env::var("CARGO_CFG_TARGET_ARCH").expect("cargo sets target arch") {
        arch if arch == "aarch64" => "arm64".to_owned(),
        arch => arch,
    };
    let deployment_target = std::env::var("IPHONEOS_DEPLOYMENT_TARGET")
        .unwrap_or_else(|_| DEFAULT_DEPLOYMENT_TARGET.to_owned());
    let swift_target = format!("{arch}-apple-ios{deployment_target}{platform_suffix}");

    let sdk_path = xcrun(sdk, &["--show-sdk-path"]);
    let out_dir = PathBuf::from(std::env::var("OUT_DIR").expect("cargo sets OUT_DIR"));
    let lib_path = out_dir.join(format!("lib{LIB_NAME}.a"));

    build_swift(sdk, &swift_target, &sdk_path, &lib_path);

    println!("cargo:rustc-link-search=native={}", out_dir.display());
    println!("cargo:rustc-link-lib=static={LIB_NAME}");
    println!("cargo:rustc-link-lib=framework=StoreKit");
    // The Swift objects carry autolink hints for the runtime; those resolve against the shared
    // Swift libraries that have shipped with iOS since 12.4.
    println!("cargo:rustc-link-search=native={sdk_path}/usr/lib/swift");
    // Swift emits calls to clang builtins such as `__chkstk_darwin`. Xcode links compiler-rt on
    // its own, but rustc drives the linker with `-nodefaultlibs`, so it has to be named here.
    // `-bundle` because compiler-rt ships as a multi-architecture archive that rustc cannot pack
    // into an rlib; it only has to reach the final link.
    println!("cargo:rustc-link-search=native={}", clang_rt_dir(sdk));
    println!("cargo:rustc-link-lib=static:-bundle={clang_rt}");
}

/// compiler-rt lives next to the clang that ships with the active Xcode.
fn clang_rt_dir(sdk: &str) -> String {
    let resource_dir = Command::new("xcrun")
        .args(["--sdk", sdk, "clang", "-print-resource-dir"])
        .output()
        .expect("could not run `xcrun clang` - building for iOS requires the Xcode toolchain");

    assert!(
        resource_dir.status.success(),
        "`clang -print-resource-dir` failed: {}",
        String::from_utf8_lossy(&resource_dir.stderr)
    );

    let resource_dir = String::from_utf8(resource_dir.stdout)
        .expect("clang returned non-utf8")
        .trim()
        .to_owned();

    format!("{resource_dir}/lib/darwin")
}

/// Maps a Rust iOS target to the platform suffix `swiftc` expects on `-target`, its SDK, and the
/// matching clang runtime. Returns `None` for every non-iOS target.
fn ios_platform(target: &str) -> Option<(&'static str, &'static str, &'static str)> {
    match target {
        // `x86_64-apple-ios` is the simulator; it predates the `-sim` suffix.
        "x86_64-apple-ios" => Some(("-simulator", "iphonesimulator", "clang_rt.iossim")),
        t if t.ends_with("-apple-ios-sim") => {
            Some(("-simulator", "iphonesimulator", "clang_rt.iossim"))
        }
        t if t.ends_with("-apple-ios") => Some(("", "iphoneos", "clang_rt.ios")),
        _ => None,
    }
}

fn build_swift(sdk: &str, swift_target: &str, sdk_path: &str, lib_path: &Path) {
    let optimization = if std::env::var("PROFILE").as_deref() == Ok("release") {
        "-O"
    } else {
        "-Onone"
    };

    let status = Command::new("xcrun")
        .args(["--sdk", sdk, "swiftc"])
        .args(["-emit-library", "-static"])
        .arg("-o")
        .arg(lib_path)
        .args(["-target", swift_target])
        .args(["-sdk", sdk_path])
        .args(["-module-name", "BevyIosIapSwift"])
        .args(["-import-objc-header", BRIDGE_HEADER])
        .args([optimization, "-wmo"])
        .arg(SWIFT_SOURCE)
        .status()
        .expect("could not run `xcrun swiftc` - building for iOS requires the Xcode toolchain");

    assert!(status.success(), "failed to compile {SWIFT_SOURCE}");
}

fn xcrun(sdk: &str, args: &[&str]) -> String {
    let output = Command::new("xcrun")
        .args(["--sdk", sdk])
        .args(args)
        .output()
        .expect("could not run `xcrun` - building for iOS requires the Xcode toolchain");

    assert!(
        output.status.success(),
        "`xcrun --sdk {sdk} {}` failed: {}",
        args.join(" "),
        String::from_utf8_lossy(&output.stderr)
    );

    String::from_utf8(output.stdout)
        .expect("xcrun returned non-utf8")
        .trim()
        .to_owned()
}
