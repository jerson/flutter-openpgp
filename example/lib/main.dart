import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/encrypt_decrypt.dart';
import 'package:openpgp_example/encrypt_decrypt_bytes.dart';
import 'package:openpgp_example/encrypt_decrypt_file.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric_bytes.dart';
import 'package:openpgp_example/generate.dart';
import 'package:openpgp_example/sign_verify.dart';
import 'package:openpgp_example/sign_verify_bytes.dart';

const passphrase = 'test';

void main() {
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KeyPair? _defaultKeyPair;

  @override
  void initState() {
    super.initState();
    initKeyPair();
  }

  Future<void> initKeyPair() async {
    var keyOptions = KeyOptions()..rsaBits = 1024;
    var keyPair = await OpenPGP.generate(
        options: Options()
          ..name = 'test'
          ..email = 'test@test.com'
          ..passphrase = passphrase
          ..keyOptions = keyOptions);

    setState(() {
      _defaultKeyPair = keyPair;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_defaultKeyPair == null) {
      return Container();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenPGP example app'),
        ),
        body: ListView(
          key: Key('list'),
          children: <Widget>[
            EncryptAndDecrypt(
              title: "Encrypt And Decrypt",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt"),
            ),
            if (false)
              EncryptAndDecryptFile(
                title: "Encrypt And Decrypt file",
                keyPair: _defaultKeyPair,
                key: Key("encrypt-decrypt-file"),
              ),
            EncryptAndDecryptBytes(
              title: "Encrypt And Decrypt Bytes",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-bytes"),
            ),
            EncryptAndDecryptSymmetric(
              title: "Encrypt And Decrypt Symmetric",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-symmetric"),
            ),
            EncryptAndDecryptSymmetricBytes(
              title: "Encrypt And Decrypt Symmetric Bytes",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-symmetric-bytes"),
            ),
            SignAndVerify(
              title: "Sign And Verify",
              keyPair: _defaultKeyPair,
              key: Key("sign-verify"),
            ),
            SignAndVerifyBytes(
              title: "Sign And Verify Bytes",
              keyPair: _defaultKeyPair,
              key: Key("sign-verify-bytes"),
            ),
            Generate(
              title: "Generate",
              key: Key("generate"),
            ),
          ],
        ),
      ),
    );
  }
}
