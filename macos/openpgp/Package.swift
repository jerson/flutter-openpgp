// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Swift Package Manager support for the `openpgp` Flutter plugin (macOS).
// The CocoaPods podspec (../openpgp.podspec) is kept in parallel; Flutter uses
// this package when SPM is enabled and falls back to the podspec otherwise.

import PackageDescription

let package = Package(
    name: "openpgp",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "openpgp", targets: ["openpgp"])
    ],
    dependencies: [
        // Provided by the Flutter tool when SPM is enabled (Flutter 3.41+).
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // Prebuilt Go bridge. Upstream ships macOS as a dynamic library
        // (libopenpgp_bridge.dylib); scripts/upgrade_bridge_libs.sh fetches it
        // into macos/ and scripts/build_macos_xcframework.sh wraps it into this
        // xcframework (inside this package dir) so SPM can embed and code-sign it.
        // The path must be package-relative: Flutter copies the package into an
        // ephemeral .packages/ location at build time, so '..' would escape it.
        //
        // The wrapped library keeps its leaf name (libopenpgp_bridge.dylib) and is
        // linked as a load-time dependency, so DynamicLibrary.open(
        // 'libopenpgp_bridge.dylib') in lib/bridge/binding.dart resolves the
        // already-loaded image at runtime — no Dart loader change required.
        .binaryTarget(
            name: "OpenPGPBridge",
            path: "OpenPGPBridge.xcframework"
        ),
        .target(
            name: "openpgp",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                "OpenPGPBridge"
            ]
        )
    ]
)
