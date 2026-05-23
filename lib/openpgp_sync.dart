import 'dart:typed_data';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp/openpgp_bridge.dart';
import 'package:openpgp/mixin/openpgp_request_builders.dart';
import 'package:openpgp/mixin/openpgp_response_handlers.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

/// Synchronous variants of every [OpenPGP] operation.
///
/// These block the calling thread and are only available on platforms where
/// FFI is supported ([OpenPGPSync.available] == true). Web is not supported.
extension OpenPGPSync on OpenPGP {
  static bool available = OpenPGPBridge.bindingEnabled;

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static Uint8List _call(String op, model.ObjectBuilder req) =>
      OpenPGPBridge.callSync(op, req.toBytes());

  // ── Decrypt ─────────────────────────────────────────────────────────────────

  static String decrypt(String message, String privateKey, String passphrase,
          {KeyOptions? options, Entity? signed}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'decrypt',
          model.DecryptRequestObjectBuilder(
            message: message,
            privateKey: privateKey,
            passphrase: passphrase,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
            signed: OpenPGPRequestBuilders.entityBuilder(signed),
          )));

  static Uint8List decryptBytes(
          Uint8List message, String privateKey, String passphrase,
          {KeyOptions? options, Entity? signed}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'decryptBytes',
          model.DecryptBytesRequestObjectBuilder(
            message: message,
            privateKey: privateKey,
            passphrase: passphrase,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
            signed: OpenPGPRequestBuilders.entityBuilder(signed),
          )));

  static String decryptSymmetric(String message, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'decryptSymmetric',
          model.DecryptSymmetricRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static Uint8List decryptSymmetricBytes(Uint8List message, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'decryptSymmetricBytes',
          model.DecryptSymmetricBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  // ── Encrypt ─────────────────────────────────────────────────────────────────

  static String encrypt(String message, String publicKey,
          {KeyOptions? options, Entity? signed, FileHints? fileHints}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'encrypt',
          model.EncryptRequestObjectBuilder(
            publicKey: publicKey,
            message: message,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
            signed: OpenPGPRequestBuilders.entityBuilder(signed),
            fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
          )));

  static Uint8List encryptBytes(Uint8List message, String publicKey,
          {KeyOptions? options, Entity? signed, FileHints? fileHints}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'encryptBytes',
          model.EncryptBytesRequestObjectBuilder(
            publicKey: publicKey,
            message: message,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
            signed: OpenPGPRequestBuilders.entityBuilder(signed),
            fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
          )));

  static String encryptSymmetric(String message, String passphrase,
          {KeyOptions? options, FileHints? fileHints}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'encryptSymmetric',
          model.EncryptSymmetricRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static Uint8List encryptSymmetricBytes(Uint8List message, String passphrase,
          {KeyOptions? options, FileHints? fileHints}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'encryptSymmetricBytes',
          model.EncryptSymmetricBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  // ── Sign ────────────────────────────────────────────────────────────────────

  static String sign(String message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'sign',
          model.SignRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static Uint8List signBytes(
          Uint8List message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'signBytes',
          model.SignBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static String signBytesToString(
          Uint8List message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'signBytesToString',
          model.SignBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static String signData(String message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'signData',
          model.SignDataRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static Uint8List signDataBytes(
          Uint8List message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.bytesResponse(_call(
          'signDataBytes',
          model.SignDataBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  static String signDataBytesToString(
          Uint8List message, String privateKey, String passphrase,
          {KeyOptions? options}) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'signDataBytesToString',
          model.SignDataBytesRequestObjectBuilder(
            message: message,
            passphrase: passphrase,
            privateKey: privateKey,
            options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
          )));

  // ── Verify ──────────────────────────────────────────────────────────────────

  static bool verify(String signature, String message, String publicKey) =>
      OpenPGPResponseHandlers.boolResponse(_call(
          'verify',
          model.VerifyRequestObjectBuilder(
            publicKey: publicKey,
            message: message,
            signature: signature,
          )));

  static bool verifyBytes(
          String signature, Uint8List message, String publicKey) =>
      OpenPGPResponseHandlers.boolResponse(_call(
          'verifyBytes',
          model.VerifyBytesRequestObjectBuilder(
            publicKey: publicKey,
            message: message,
            signature: signature,
          )));

  static bool verifyData(String signature, String publicKey) =>
      OpenPGPResponseHandlers.boolResponse(_call(
          'verifyData',
          model.VerifyDataRequestObjectBuilder(
            publicKey: publicKey,
            signature: signature,
          )));

  static bool verifyDataBytes(Uint8List signature, String publicKey) =>
      OpenPGPResponseHandlers.boolResponse(_call(
          'verifyDataBytes',
          model.VerifyDataBytesRequestObjectBuilder(
            publicKey: publicKey,
            signature: signature,
          )));

  // ── Armor ───────────────────────────────────────────────────────────────────

  static String armorEncode(String type, Uint8List data) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'armorEncode',
          model.ArmorEncodeRequestObjectBuilder(
            packet: data,
            type: type,
          )));

  static ArmorMetadata armorDecode(String message) =>
      OpenPGPResponseHandlers.armorDecodeResponse(_call(
          'armorDecode',
          model.ArmorDecodeRequestObjectBuilder(
            message: message,
          )));

  // ── Keys ────────────────────────────────────────────────────────────────────

  static String convertPrivateKeyToPublicKey(String privateKey) =>
      OpenPGPResponseHandlers.stringResponse(_call(
          'convertPrivateKeyToPublicKey',
          model.ConvertPrivateKeyToPublicKeyRequestObjectBuilder(
            privateKey: privateKey,
          )));

  static PrivateKeyMetadata getPrivateKeyMetadata(String privateKey) =>
      OpenPGPResponseHandlers.privateKeyMetadataResponse(_call(
          'getPrivateKeyMetadata',
          model.GetPrivateKeyMetadataRequestObjectBuilder(
            privateKey: privateKey,
          )));

  static PublicKeyMetadata getPublicKeyMetadata(String publicKey) =>
      OpenPGPResponseHandlers.publicKeyMetadataResponse(_call(
          'getPublicKeyMetadata',
          model.GetPublicKeyMetadataRequestObjectBuilder(
            publicKey: publicKey,
          )));

  static KeyPair generate({Options? options}) =>
      OpenPGPResponseHandlers.keyPairResponse(_call(
          'generate',
          model.GenerateRequestObjectBuilder(
            options: OpenPGPRequestBuilders.optionsBuilder(options),
          )));
}
