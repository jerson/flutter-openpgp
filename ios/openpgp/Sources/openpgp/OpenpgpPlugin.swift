import Flutter
import UIKit
import OpenPGPBridge

public class OpenpgpPlugin: NSObject, FlutterPlugin {
  // Retains the Go bridge entry point so the linker keeps the symbol in the final
  // app binary. `OpenPGPBridgeCall` is resolved at runtime via
  // DynamicLibrary.process() == dlsym(RTLD_DEFAULT, "OpenPGPBridgeCall") (see
  // lib/bridge/binding.dart); nothing calls it at compile time, so without a hard
  // reference the linker dead-strips it and the lookup fails with "symbol not found".
  //
  // This is a *public static* (not a discarded local) on purpose: the optimizer
  // cannot prove it is unused, so it must emit the address load, producing a
  // relocation to OpenPGPBridgeCall that survives dead-stripping. The earlier
  // discarded-value form was elided, which is why SPM builds failed the lookup.
  // Combined with -export_dynamic (see Package.swift) this replaces the CocoaPods
  // -force_load, whose archive path is not addressable under SwiftPM.
  public static var bridgeEntryPoint: UnsafeRawPointer?

  public static func register(with registrar: FlutterPluginRegistrar) {
    bridgeEntryPoint = unsafeBitCast(
      OpenPGPBridgeCall as @convention(c) (
        UnsafeMutablePointer<CChar>?, UnsafeMutableRawPointer?, Int32
      ) -> UnsafeMutablePointer<BytesReturn>?,
      to: UnsafeRawPointer.self)
    let channel = FlutterMethodChannel(name: "openpgp", binaryMessenger: registrar.messenger())
    let instance = OpenpgpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "init":
      result("success")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
