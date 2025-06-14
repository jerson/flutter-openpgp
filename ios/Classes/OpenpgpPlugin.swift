import Flutter
import UIKit
import OpenPGPBridge

public class OpenpgpPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "openpgp", binaryMessenger: registrar.messenger())
    let instance = OpenpgpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "init":
      _ = OpenPGPBridge.OpenPGPEncodeText(nil, nil)
      _ = OpenPGPBridge.OpenPGPBridgeCall(nil, nil, 0)
      _ = OpenPGPBridge.OpenPGPDecodeText(nil, 0, nil, 0, 0, 0)
      result("success")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
