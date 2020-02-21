import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';

const passphrase = 'test';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final encryptController = TextEditingController();
  final encryptSymmetricController = TextEditingController();
  final signController = TextEditingController();

  KeyPair _defaultKeyPair;

  KeyPair _keyPair = KeyPair(
    privateKey: "",
    publicKey: "",
  );
  String _encrypted = "";
  String _decrypted = "";
  String _encryptedSymmetric = "";
  String _decryptedSymmetric = "";
  String _signed = "";
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    initKeyPair();

    encryptController.text = "sample";
    encryptSymmetricController.text = "sample";
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
    encryptController.dispose();
    encryptSymmetricController.dispose();
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
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Message"),
                        controller: encryptController,
                      ),
                      RaisedButton(
                        child: Text("Encrypt"),
                        onPressed: () async {
                          var encrypted = await OpenPGP.encrypt(
                            encryptController.text,
                            _defaultKeyPair.publicKey,
                          );
                          setState(() {
                            _encrypted = encrypted;
                          });
                        },
                      ),
                      SelectableText(_encrypted)
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
                        child: Text("Decrypt"),
                        onPressed: () async {
                          var decrypted = await OpenPGP.decrypt(
                            _encrypted,
                            _defaultKeyPair.privateKey,
                            passphrase,
                          );
                          setState(() {
                            _decrypted = decrypted;
                          });
                        },
                      ),
                      SelectableText(_decrypted)
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
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Message"),
                        controller: encryptSymmetricController,
                      ),
                      RaisedButton(
                        child: Text("Encrypt Symmetric"),
                        onPressed: () async {
                          var encrypted = await OpenPGP.encryptSymmetric(
                            encryptSymmetricController.text,
                            passphrase,
                          );
                          setState(() {
                            _encryptedSymmetric = encrypted;
                          });
                        },
                      ),
                      SelectableText(_encryptedSymmetric)
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
                        child: Text("Decrypt Symmetric"),
                        onPressed: () async {
                          var decrypted = await OpenPGP.decryptSymmetric(
                            _encryptedSymmetric,
                            passphrase,
                          );
                          setState(() {
                            _decryptedSymmetric = decrypted;
                          });
                        },
                      ),
                      SelectableText(_decryptedSymmetric)
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
                        child: Text("Generate"),
                        onPressed: () async {
                          var keyPair = await OpenPGP.generate(
                            options: Options(
                              name: 'test',
                              email: 'test@test.com',
                              passphrase: 'test',
                              keyOptions: KeyOptions(
                                rsaBits: 1024,
                              ),
                            ),
                          );
                          setState(() {
                            _keyPair = keyPair;
                          });
                        },
                      ),
                      SelectableText(_keyPair.publicKey),
                      SelectableText(_keyPair.privateKey)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
