import 'package:openpgp/binding/functions.dart';
import 'package:openpgp/binding/key_options.dart';
import 'package:openpgp/binding/key_pair.dart';
import 'package:openpgp/binding/options.dart';
import 'package:openpgp/binding/return.dart';
import 'package:openpgp/ffi.dart';
import 'package:openpgp/models.dart';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:openpgp/shared.dart';

class Binding {
  static final Binding _singleton = Binding._internal();
  ffi.DynamicLibrary _library;

  factory Binding() {
    return _singleton;
  }

  Binding._internal() {
    _library = openLib();
  }

  String decrypt(String message, String privateKey, String passphrase) {
    final callable = _library
        .lookup<ffi.NativeFunction<decrypt_func>>('Decrypt')
        .asFunction<Decrypt>();

    var result =
        callable(toUtf8(message), toUtf8(privateKey), toUtf8(passphrase))
            .cast<ffiStringReturn>()
            .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output;
  }

  String encrypt(String message, String publicKey) {
    final callable = _library
        .lookup<ffi.NativeFunction<encrypt_func>>('Encrypt')
        .asFunction<Encrypt>();

    var result = callable(toUtf8(message), toUtf8(publicKey))
        .cast<ffiStringReturn>()
        .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output;
  }

  String sign(
      String message, String publicKey, String privateKey, String passphrase) {
    final callable = _library
        .lookup<ffi.NativeFunction<sign_func>>('Sign')
        .asFunction<Sign>();

    var result = callable(toUtf8(message), toUtf8(publicKey),
            toUtf8(privateKey), toUtf8(passphrase))
        .cast<ffiStringReturn>()
        .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output;
  }

  bool verify(String signature, String message, String publicKey) {
    final callable = _library
        .lookup<ffi.NativeFunction<verify_func>>('Verify')
        .asFunction<Verify>();

    var result = callable(toUtf8(signature), toUtf8(message), toUtf8(publicKey))
        .cast<ffiStringReturn>()
        .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output == "1";
  }

  String decryptSymmetric(String message, String passphrase,
      {KeyOptions options}) {
    final callable = _library
        .lookup<ffi.NativeFunction<decryptSymmetric_func>>('DecryptSymmetric')
        .asFunction<DecryptSymmetric>();

    var keyOptions = _getKeyOptions(options);
    var result =
        callable(toUtf8(message), toUtf8(passphrase), keyOptions.addressOf)
            .cast<ffiStringReturn>()
            .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output;
  }

  String encryptSymmetric(String message, String passphrase,
      {KeyOptions options}) {
    final callable = _library
        .lookup<ffi.NativeFunction<encryptSymmetric_func>>('EncryptSymmetric')
        .asFunction<EncryptSymmetric>();

    var keyOptions = _getKeyOptions(options);
    var result =
        callable(toUtf8(message), toUtf8(passphrase), keyOptions.addressOf)
            .cast<ffiStringReturn>()
            .ref;

    handleError(result.error, result.addressOf);

    var output = fromUtf8(result.result);
    free(result.addressOf);
    return output;
  }

  KeyPair generate(Options originalOptions) {
    final callable = _library
        .lookup<ffi.NativeFunction<generate_func>>('Generate')
        .asFunction<Generate>();

    var options = _getOptions(originalOptions);
    var result = callable(
      options.addressOf.cast(),
    ).cast<ffiKeyPairReturn>().ref;

    handleError(result.error, result.addressOf);

    var keyPair = result.keyPair.ref;
    var output = KeyPair(
      privateKey: fromUtf8(keyPair.privateKey),
      publicKey: fromUtf8(keyPair.publicKey),
    );

    free(result.addressOf);
    return output;
  }

  void handleError(ffi.Pointer<Utf8> error, ffi.Pointer pointer) {
    print(error);
    print(error.toString());
    print(error.address);
    print(error.address.bitLength);
    if (error.address != ffi.nullptr.address) {
      var message = fromUtf8(error);
      free(pointer);
      throw message;
    }
  }

  ffiOptions _getOptions(Options originalOptions) {
    if (originalOptions == null) {
      return ffiOptions.allocate(
        toUtf8(""),
        toUtf8(""),
        toUtf8(""),
        toUtf8(""),
        _getKeyOptions(null),
      );
    }
    return ffiOptions.allocate(
      toUtf8(originalOptions.name),
      toUtf8(originalOptions.comment),
      toUtf8(originalOptions.email),
      toUtf8(originalOptions.passphrase),
      _getKeyOptions(originalOptions.keyOptions),
    );
  }

  ffiKeyOptions _getKeyOptions(KeyOptions originalOptions) {
    if (originalOptions == null) {
      return ffiKeyOptions.allocate(
        toUtf8(""),
        toUtf8(""),
        toUtf8(""),
        toUtf8(""),
        toUtf8(""),
      );
    }
    return ffiKeyOptions.allocate(
      toUtf8(toStringHash(originalOptions.hash)),
      toUtf8(toStringCypher(originalOptions.cipher)),
      toUtf8(toStringCompression(originalOptions.compression)),
      toUtf8(originalOptions.compressionLevel.toString()),
      toUtf8(originalOptions.rsaBits.toString()),
    );
  }

  ffi.Pointer<Utf8> toUtf8(String text) {
    return text == null ? Utf8.toUtf8("") : Utf8.toUtf8(text);
  }

  String fromUtf8(ffi.Pointer<Utf8> text) {
    return text == null ? "" : Utf8.fromUtf8(text);
  }
}
