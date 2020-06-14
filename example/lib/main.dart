import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';
import 'package:openpgp_example/encrypt_decrypt.dart';
import 'package:openpgp_example/encrypt_decrypt_bytes.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric_bytes.dart';
import 'package:openpgp_example/generate.dart';

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
  final signController = TextEditingController();

  KeyPair _defaultKeyPair;
  String _signed = "";
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    initKeyPair();

    signController.text = "sample";
  }

  Future<void> initKeyPair() async {
    var keyPair = await OpenPGP.generate(
      options: Options(
        name: 'test',
        email: 'test@test.com',
        passphrase: passphrase,
        keyOptions: KeyOptions(
          rsaBits: 1024,
        ),
      ),
    );

    setState(() {
      _defaultKeyPair = keyPair;
    });
  }

  @override
  void dispose() {
    signController.dispose();
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
          children: <Widget>[
            EncryptAndDecrypt(
              title: "Encrypt And Decrypt",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt"),
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
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Message"),
                        controller: signController,
                      ),
                      RaisedButton(
                        child: Text("Sign"),
                        onPressed: () async {
                          var signed = await OpenPGP.sign(
                            signController.text,
                            _defaultKeyPair.publicKey,
                            _defaultKeyPair.privateKey,
                            passphrase,
                          );
                          setState(() {
                            _signed = signed;
                          });
                        },
                      ),
                      SelectableText(_signed)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Verify"),
                        onPressed: () async {
                          var verified = await OpenPGP.verify(
                            _signed,
                            signController.text,
                            _defaultKeyPair.publicKey,
                          );
                          setState(() {
                            _verified = verified;
                          });
                        },
                      ),
                      SelectableText(_verified ? "VALID" : "INVALID")
                    ],
                  ),
                ),
              ),
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
