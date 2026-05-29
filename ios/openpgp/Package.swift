// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Swift Package Manager support for the `openpgp` Flutter plugin (iOS).
// The CocoaPods podspec (../openpgp.podspec) is kept in parallel; Flutter uses
// this package when SPM is enabled and falls back to the podspec otherwise.

import PackageDescription

let package = Package(
    name: "openpgp",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "openpgp", targets: ["openpgp"])
    ],
    dependencies: [
        // Provided by the Flutter tool when SPM is enabled (Flutter 3.41+).
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // Prebuilt Go bridge, shipped as a static xcframework. It must live inside
        // this package directory: Flutter copies the SwiftPM package into an
        // ephemeral .packages/ location at build time, so a parent-relative path
        // would escape the copied tree. scripts/upgrade_bridge_libs.sh fetches it here.
        .binaryTarget(
            name: "OpenPGPBridge",
            path: "OpenPGPBridge.xcframework"
        ),
        .target(
            name: "openpgp",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                "OpenPGPBridge"
            ],
            linkerSettings: [
                // The bridge is a static framework whose only entry point
                // (OpenPGPBridgeCall) is resolved at runtime via
                // DynamicLibrary.process() == dlsym(RTLD_DEFAULT, ...). Two flags are
                // needed so that lookup succeeds, replacing the podspec's -force_load:
                //   * OpenpgpPlugin.keepBridgeSymbols() holds a reachable reference so
                //     the linker pulls the symbol (and its object) out of the static
                //     archive instead of dead-stripping it.
                //   * -export_dynamic places the linked global symbols into the app's
                //     dynamic symbol table; without it the symbol exists in the binary
                //     but dlsym(RTLD_DEFAULT) cannot find it ("symbol not found").
                // -ObjC additionally retains any Objective-C categories from the
                // archive. unsafeFlags are permitted because Flutter consumes plugin
                // packages as local path dependencies.
                .unsafeFlags(["-Xlinker", "-ObjC", "-Xlinker", "-export_dynamic"])
            ]
        )
    ]
)
