import Flutter
import UIKit
import OpenPGPBridge

public class OpenpgpPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    keepBridgeSymbols()
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

  // The Go bridge is shipped as a *static* xcframework and its only entry point,
  // `OpenPGPBridgeCall`, is resolved at runtime from the host process via
  // `DynamicLibrary.process()` (see lib/bridge/binding.dart). Because no Swift/ObjC
  // code calls it at compile time, the linker would otherwise dead-strip the symbol
  // and `dlsym(RTLD_DEFAULT, "OpenPGPBridgeCall")` would fail.
  //
  // `register(with:)` is invoked by the generated plugin registrant, so taking the
  // address of the symbol here keeps it (and its object file) in the final app
  // binary. This replaces the CocoaPods `-force_load` linker flag for the Swift
  // Package Manager build, where the static archive's path is not addressable.
  @inline(never)
  private static func keepBridgeSymbols() {
    let entry: @convention(c) (
      UnsafeMutablePointer<CChar>?, UnsafeMutableRawPointer?, Int32
    ) -> UnsafeMutablePointer<BytesReturn>? = OpenPGPBridgeCall
    _ = unsafeBitCast(entry, to: UnsafeRawPointer.self)
  }
}
