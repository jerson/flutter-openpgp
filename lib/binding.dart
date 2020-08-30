import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:openpgp/ffi.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/options.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';
import 'package:openpgp/shared.dart';

typedef encrypt_func = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Encrypt = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef generate_func = ffi.Pointer<ffiKeyPair> Function(
  ffi.Pointer<ffiKeyOptions> options,
);
typedef Generate = ffi.Pointer<ffiKeyPair> Function(
  ffi.Pointer<ffiKeyOptions> options,
);

class ffiKeyPair extends ffi.Struct {
  ffi.Pointer<Utf8> publicKey;
  ffi.Pointer<Utf8> privateKey;

  factory ffiKeyPair.allocate(
    ffi.Pointer<Utf8> publicKey,
    ffi.Pointer<Utf8> privateKey,
  ) =>
      allocate<ffiKeyPair>().ref
        ..publicKey
        ..privateKey;
}

class ffiKeyOptions extends ffi.Struct {
  ffi.Pointer<Utf8> hash;
  ffi.Pointer<Utf8> cipher;
  ffi.Pointer<Utf8> compression;
  ffi.Pointer<Utf8> compressionLevel;
  ffi.Pointer<Utf8> rsaBits;

  factory ffiKeyOptions.allocate(
    ffi.Pointer<Utf8> hash,
    ffi.Pointer<Utf8> cipher,
    ffi.Pointer<Utf8> compression,
    ffi.Pointer<Utf8> compressionLevel,
    ffi.Pointer<Utf8> rsaBits,
  ) =>
      allocate<ffiKeyOptions>().ref
        ..hash
        ..cipher
        ..compression
        ..compressionLevel
        ..rsaBits;
}

class ffiOptions extends ffi.Struct {
  ffi.Pointer<Utf8> name;
  ffi.Pointer<Utf8> comment;
  ffi.Pointer<Utf8> email;
  ffi.Pointer<Utf8> passphrase;
  ffi.Pointer<ffiKeyOptions> keyOptions;

  factory ffiOptions.allocate(
    ffi.Pointer<Utf8> name,
    ffi.Pointer<Utf8> comment,
    ffi.Pointer<Utf8> email,
    ffi.Pointer<Utf8> passphrase,
    ffiKeyOptions keyOptions,
  ) =>
      allocate<ffiOptions>().ref
        ..name
        ..comment
        ..email
        ..passphrase
        ..keyOptions;
}

class Binding {
  static final Binding _singleton = Binding._internal();
  ffi.DynamicLibrary _library;

  factory Binding() {
    return _singleton;
  }

  Binding._internal() {
    _library = openLib();
  }

  String encrypt(String message, String publicKey) {
    final callable = _library
        .lookup<ffi.NativeFunction<encrypt_func>>('Encrypt')
        .asFunction<Encrypt>();

    return Utf8.fromUtf8(callable(toUtf8(message), toUtf8(publicKey)));
  }

  KeyPair generate(Options originalOptions) {
    final callable = _library
        .lookup<ffi.NativeFunction<generate_func>>('Generate')
        .asFunction<Generate>();

    var options = _getOptions(originalOptions);

    var result = callable(options.addressOf.cast()).ref;
    return KeyPair(
      privateKey: Utf8.fromUtf8(result.privateKey),
      publicKey: Utf8.fromUtf8(result.publicKey),
    );
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


  ffi.Pointer<Utf8> toUtf8(String text) =>
      text == null ? Utf8.toUtf8("") : Utf8.toUtf8(text);
}
