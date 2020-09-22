import Cocoa
import FlutterMacOS

import OpenPGPBridge


public class OpenpgpPlugin: NSObject, FlutterPlugin {
    
    private var queue: DispatchQueue?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "openpgp", binaryMessenger: registrar.messenger)
        let instance = OpenpgpPlugin()
        instance.setup()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func setup() {
        queue = DispatchQueue(label: "fast-openpgp")
    }
    
    func result(_ result: @escaping FlutterResult, output: Any?) {
        DispatchQueue.main.async(execute: {
            result(output)
        })
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        bridgeCall(
            name: call.method,
            payload: call.arguments as? FlutterStandardTypedData,
            result: result
        )
    }
    
    
    func bridgeCall( name: String?,payload: FlutterStandardTypedData?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            var error: NSError?
            
            let output = OpenPGPBridgeCall(name, payload?.data, &error)
            
            if error != nil {
                self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
            } else {
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
            }
            
        })
    }
    
    
}
