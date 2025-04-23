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
      result("success")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
