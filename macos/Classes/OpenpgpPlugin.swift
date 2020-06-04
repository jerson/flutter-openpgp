import Cocoa
import FlutterMacOS

import OpenpgpMobile


public class OpenpgpPlugin: NSObject, FlutterPlugin {
    
    private var queue: DispatchQueue?
    private var instance: OpenpgpMobileFastOpenPGP?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "openpgp", binaryMessenger: registrar.messenger)
        let instance = OpenpgpPlugin()
        instance.setup()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func setup() {
        queue = DispatchQueue(label: "fast-openpgp")
        instance = OpenpgpMobileNewFastOpenPGP()
    }
    
    func result(_ result: @escaping FlutterResult, output: Any?) {
        DispatchQueue.main.async(execute: {
            result(output)
        })
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let args = call.arguments as! [String: Any]
        
        switch call.method {
        case "encrypt":
            encrypt(
                message: args["message"] as? String,
                publicKey: args["publicKey"] as? String,
                result: result
            )
        case "encryptBytes":
            encryptBytes(
                message: args["message"] as? FlutterStandardTypedData,
                publicKey: args["publicKey"] as? String,
                result: result
            )
        case "decrypt":
            decrypt(
                message: args["message"] as? String,
                privateKey: args["privateKey"] as? String,
                passphrase: args["passphrase"] as? String,
                result: result
            )
        case "decryptBytes":
            decryptBytes(
                message: args["message"] as? FlutterStandardTypedData,
                privateKey: args["privateKey"] as? String,
                passphrase: args["passphrase"] as? String,
                result: result
            )
        case "encryptSymmetric":
            encryptSymmetric(
                message: args["message"] as? String,
                passphrase: args["passphrase"] as? String,
                options: args["options"] as! [String: Any],
                result: result
            )
        case "encryptSymmetricBytes":
            encryptSymmetricBytes(
                message: args["message"] as? FlutterStandardTypedData,
                passphrase: args["passphrase"] as? String,
                options: args["options"] as! [String: Any],
                result: result
            )
        case "decryptSymmetric":
            decryptSymmetric(
                message: args["message"] as? String,
                passphrase: args["passphrase"] as? String,
                options: args["options"] as! [String: Any],
                result: result
            )
        case "decryptSymmetricBytes":
            decryptSymmetricBytes(
                message: args["message"] as? FlutterStandardTypedData,
                passphrase: args["passphrase"] as? String,
                options: args["options"] as! [String: Any],
                result: result
            )
        case "sign":
            sign(
                message: args["message"] as? String,
                publicKey: args["publicKey"] as? String,
                privateKey: args["privateKey"] as? String,
                passphrase: args["passphrase"] as? String,
                result: result
            )
        case "signBytes":
            signBytes(
                message: args["message"] as? FlutterStandardTypedData,
                publicKey: args["publicKey"] as? String,
                privateKey: args["privateKey"] as? String,
                passphrase: args["passphrase"] as? String,
                result: result
            )
        case "signBytesToString":
            signBytesToString(
                message: args["message"] as? FlutterStandardTypedData,
                publicKey: args["publicKey"] as? String,
                privateKey: args["privateKey"] as? String,
                passphrase: args["passphrase"] as? String,
                result: result
            )
        case "verify":
            verify(
                signature: args["signature"] as? String,
                message: args["message"] as? String,
                publicKey: args["publicKey"] as? String,
                result: result
            )
        case "verifyBytes":
            verifyBytes(
                signature: args["signature"] as? String,
                message: args["message"] as? FlutterStandardTypedData,
                publicKey: args["publicKey"] as? String,
                result: result
            )
        case "generate":
            generate(
                options: args["options"] as! [String: Any],
                result: result
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func encrypt(message: String?, publicKey: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.encrypt(message, publicKey: publicKey, error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    
    func encryptBytes(message: FlutterStandardTypedData?, publicKey: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.encryptBytes(message?.data, publicKey: publicKey)
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func decrypt(message: String?, privateKey: String?, passphrase: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.decrypt(message, privateKey: privateKey, passphrase: passphrase, error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    
    func decryptBytes(message: FlutterStandardTypedData?, privateKey: String?, passphrase: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.decryptBytes(message?.data, privateKey: privateKey, passphrase: passphrase)
                
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func encryptSymmetric(message: String?, passphrase: String?, options: [String: Any], result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.encryptSymmetric(message, passphrase: passphrase, options: self.getKeyOptions(options), error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func encryptSymmetricBytes(message: FlutterStandardTypedData?, passphrase: String?, options: [String: Any], result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.encryptSymmetricBytes(message?.data, passphrase: passphrase, options: self.getKeyOptions(options))
                
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
                
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func decryptSymmetric(message: String?, passphrase: String?, options: [String: Any], result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.decryptSymmetric(message, passphrase: passphrase, options: self.getKeyOptions(options), error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func decryptSymmetricBytes(message: FlutterStandardTypedData?, passphrase: String?, options: [String: Any], result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.decryptSymmetricBytes(message?.data, passphrase: passphrase, options: self.getKeyOptions(options))
                
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
                
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func sign(message: String?, publicKey: String?, privateKey: String?, passphrase: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.sign(message, publicKey: publicKey, privateKey: privateKey, passphrase: passphrase, error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func signBytes(message: FlutterStandardTypedData?, publicKey: String?, privateKey: String?, passphrase: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.signBytes(message?.data, publicKey: publicKey, privateKey: privateKey, passphrase: passphrase)
                
                self.result(result, output: FlutterStandardTypedData.init(bytes: output!))
                
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func signBytesToString(message: FlutterStandardTypedData?, publicKey: String?, privateKey: String?, passphrase: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var error: NSError?
                let output = try self.instance?.signBytes(toString:message?.data, publicKey: publicKey, privateKey: privateKey, passphrase: passphrase, error: &error)
                
                if error != nil {
                    self.result(result, output: FlutterError(code: String(format: "%ld", error?.code ?? 0), message: error?.description, details: nil))
                } else {
                    self.result(result, output: output)
                }
                
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func verify(signature: String?, message: String?, publicKey: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var ret0_: ObjCBool = false
                _ = try self.instance?.verify(signature, message: message, publicKey: publicKey, ret0_: &ret0_)
                
                self.result(result, output: ret0_.boolValue as NSNumber)
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func verifyBytes(signature: String?, message: FlutterStandardTypedData?, publicKey: String?, result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                var ret0_: ObjCBool = false
                _ = try self.instance?.verifyBytes(signature, message: message?.data, publicKey: publicKey, ret0_: &ret0_)
                
                self.result(result, output: ret0_.boolValue as NSNumber)
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func generate(options: [String: Any], result: @escaping FlutterResult) {
        queue?.async(execute: {
            do {
                let output = try self.instance?.generate(self.getOptions(options))
                
                self.result(result, output: [
                    "publicKey": output?.publicKey,
                    "privateKey": output?.privateKey,
                ])
                
            } catch {
                self.result(result, output: FlutterError(code: "error", message: error.localizedDescription, details: nil))
            }
        })
    }
    
    func getKeyOptions(_ map: [String : Any]?) -> OpenpgpMobileKeyOptions {
        let options = OpenpgpMobileKeyOptions()
        if map == nil {
            return options
        }
        if map?["cipher"] != nil {
            options.cipher = map?["cipher"] as! String
        }
        if map?["compression"] != nil {
            options.compression = map?["compression"] as! String
        }
        if map?["hash"] != nil {
            options.hash = map?["hash"] as! String
        }
        if map?["rsaBits"] != nil {
            options.setRSABitsFrom(String(format: "%@",  map?["rsaBits"]  as! NSNumber))
        }
        if map?["compressionLevel"] != nil {
            options.setCompressionLevelFrom(String(format: "%@",  map?["compressionLevel"]  as! NSNumber))
        }
        return options
    }
    
    func getOptions(_ map: [String : Any]?) -> OpenpgpMobileOptions {
        let options = OpenpgpMobileOptions()
        if map == nil {
            return options
        }
        if map?["name"] != nil {
            options.name = map?["name"] as! String
        }
        if map?["email"] != nil {
            options.email = map?["email"] as! String
        }
        if map?["comment"] != nil {
            options.comment = map?["comment"] as! String
        }
        if map?["passphrase"] != nil {
            options.passphrase = map?["passphrase"] as! String
        }
        if map?["keyOptions"] != nil {
            options.keyOptions = self.getKeyOptions(map?["keyOptions"] as? [String : Any])
        }
        
        return options
    }
    
}
