import 'dart:typed_data';

import 'package:openpgp/model/bridge_model_generated.dart' as model;
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/openpgp_bridge.dart';
import 'package:openpgp/mixin/openpgp_request_builders.dart';
import 'package:openpgp/mixin/openpgp_response_handlers.dart';

extension OpenPGPSync on OpenPGP {
  static bool available = OpenPGPBridge.bindingEnabled;
  static String decrypt(String message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) {
    var requestBuilder = model.DecryptRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("decrypt", requestBuilder.toBytes()));
  }

  static Uint8List decryptBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) {
    var requestBuilder = model.DecryptBytesRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
    );

    return OpenPGPResponseHandlers.bytesResponse(
        OpenPGPBridge.callSync("decryptBytes", requestBuilder.toBytes()));
  }

  static String encrypt(String message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) {
    var requestBuilder = model.EncryptRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("encrypt", requestBuilder.toBytes()));
  }

  static Uint8List encryptBytes(Uint8List message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) {
    var requestBuilder = model.EncryptBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
    );

    return OpenPGPResponseHandlers.bytesResponse(
        OpenPGPBridge.callSync("encryptBytes", requestBuilder.toBytes()));
  }

  static String sign(String message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("sign", requestBuilder.toBytes()));
  }

  static Uint8List signBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.bytesResponse(
        OpenPGPBridge.callSync("signBytes", requestBuilder.toBytes()));
  }

  static String signBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("signBytesToString", requestBuilder.toBytes()));
  }

  static String signData(String message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignDataRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("signData", requestBuilder.toBytes()));
  }

  static Uint8List signDataBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.bytesResponse(
        OpenPGPBridge.callSync("signDataBytes", requestBuilder.toBytes()));
  }

  static String signDataBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(OpenPGPBridge.callSync(
        "signDataBytesToString", requestBuilder.toBytes()));
  }

  static bool verify(String signature, String message, String publicKey) {
    var requestBuilder = model.VerifyRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return OpenPGPResponseHandlers.boolResponse(
        OpenPGPBridge.callSync("verify", requestBuilder.toBytes()));
  }

  static bool verifyBytes(
      String signature, Uint8List message, String publicKey) {
    var requestBuilder = model.VerifyBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return OpenPGPResponseHandlers.boolResponse(
        OpenPGPBridge.callSync("verifyBytes", requestBuilder.toBytes()));
  }

  static bool verifyData(String signature, String publicKey) {
    var requestBuilder = model.VerifyDataRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return OpenPGPResponseHandlers.boolResponse(
        OpenPGPBridge.callSync("verifyData", requestBuilder.toBytes()));
  }

  static bool verifyDataBytes(Uint8List signature, String publicKey) {
    var requestBuilder = model.VerifyDataBytesRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return OpenPGPResponseHandlers.boolResponse(
        OpenPGPBridge.callSync("verifyDataBytes", requestBuilder.toBytes()));
  }

  static String decryptSymmetric(String message, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.DecryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("decryptSymmetric", requestBuilder.toBytes()));
  }

  static Uint8List decryptSymmetricBytes(Uint8List message, String passphrase,
      {KeyOptions? options}) {
    var requestBuilder = model.DecryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.bytesResponse(OpenPGPBridge.callSync(
        "decryptSymmetricBytes", requestBuilder.toBytes()));
  }

  static String encryptSymmetric(String message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) {
    var requestBuilder = model.EncryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("encryptSymmetric", requestBuilder.toBytes()));
  }

  static Uint8List encryptSymmetricBytes(Uint8List message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) {
    var requestBuilder = model.EncryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPResponseHandlers.bytesResponse(OpenPGPBridge.callSync(
        "encryptSymmetricBytes", requestBuilder.toBytes()));
  }

  static String armorEncode(String type, Uint8List data) {
    var requestBuilder = model.ArmorEncodeRequestObjectBuilder(
      packet: data,
      type: type,
    );

    return OpenPGPResponseHandlers.stringResponse(
        OpenPGPBridge.callSync("armorEncode", requestBuilder.toBytes()));
  }

  static ArmorMetadata armorDecode(String message) {
    var requestBuilder = model.ArmorDecodeRequestObjectBuilder(
      message: message,
    );

    return OpenPGPResponseHandlers.armorDecodeResponse(
        OpenPGPBridge.callSync("armorDecode", requestBuilder.toBytes()));
  }

  static String convertPrivateKeyToPublicKey(String privateKey) {
    var requestBuilder = model.ConvertPrivateKeyToPublicKeyRequestObjectBuilder(
      privateKey: privateKey,
    );

    return OpenPGPResponseHandlers.stringResponse(OpenPGPBridge.callSync(
        "convertPrivateKeyToPublicKey", requestBuilder.toBytes()));
  }

  static PrivateKeyMetadata getPrivateKeyMetadata(String privateKey) {
    var requestBuilder = model.GetPrivateKeyMetadataRequestObjectBuilder(
      privateKey: privateKey,
    );

    return OpenPGPResponseHandlers.privateKeyMetadataResponse(
        OpenPGPBridge.callSync(
            "getPrivateKeyMetadata", requestBuilder.toBytes()));
  }

  static PublicKeyMetadata getPublicKeyMetadata(String publicKey) {
    var requestBuilder = model.GetPublicKeyMetadataRequestObjectBuilder(
      publicKey: publicKey,
    );

    return OpenPGPResponseHandlers.publicKeyMetadataResponse(
        OpenPGPBridge.callSync(
            "getPublicKeyMetadata", requestBuilder.toBytes()));
  }

  static KeyPair generate({Options? options}) {
    var requestBuilder = model.GenerateRequestObjectBuilder(
      options: OpenPGPRequestBuilders.optionsBuilder(options),
    );
    return OpenPGPResponseHandlers.keyPairResponse(
        OpenPGPBridge.callSync("generate", requestBuilder.toBytes()));
  }
}
