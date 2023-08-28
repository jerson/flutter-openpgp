# OpenPGP

Library for use openPGP with support for android, ios, macos, windows, linux and web

[![Integration Tests Android](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_android.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_android.yml)

[![Integration Tests Linux](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_linux.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_linux.yml)

[![Integration Tests Windows](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_windows.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_windows.yml)

[![Integration Tests iOS](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_ios.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_ios.yml)

[![Integration Tests macOS](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_macos.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_macos.yml)
## Contents
 
- [OpenPGP](#openpgp)
  - [Contents](#contents)
  - [Usage](#usage)
  - [Generate methods](#generate-methods)
    - [Encrypt methods](#encrypt-methods)
    - [Decrypt methods](#decrypt-methods)
    - [Sign methods](#sign-methods)
    - [Verify methods](#verify-methods)
    - [Encode methods](#encode-methods)
    - [Metadata methods](#metadata-methods)
    - [Convert methods](#convert-methods)
  - [Setup](#setup)
    - [Android](#android)
    - [iOS](#ios)
    - [Web](#web)
    - [MacOS](#macos)
    - [Linux](#linux)
    - [Windows](#windows)
  - [Example](#example)
  - [Native Code](#native-code)
  - [Upgrade Library](#upgrade-library)
  - [Tests](#tests)

## Usage

## Generate methods
```dart
import 'package:openpgp/openpgp.dart';

void main() async {
    var keyOptions = KeyOptions()..rsaBits = 2048;
    var keyPair = await OpenPGP.generate(
            options: Options()
              ..name = 'test'
              ..email = 'test@test.com'
              ..passphrase = passphrase
              ..keyOptions = keyOptions);
}
```

### Encrypt methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.encrypt("text","[publicKey here]");
    var result = await OpenPGP.encryptSymmetric("text","[passphrase here]");
    var result = await OpenPGP.encryptBytes(bytesSample,"[publicKey here]");
    var result = await OpenPGP.encryptSymmetricBytes(bytesSample,"[passphrase here]");

}

```

### Decrypt methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.decrypt("text encrypted","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.decryptSymmetric("text encrypted","[passphrase here]");
    var result = await OpenPGP.decryptBytes(bytesSample,"[privateKey here]","[passphrase here]");
    var result = await OpenPGP.decryptSymmetricBytes(bytesSample,"[passphrase here]");

}
```

### Sign methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.sign("text","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.signBytesToString(bytesSample,"[privateKey here]","[passphrase here]");
    
    // sign including data
    var result = await OpenPGP.signData("text","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.signDataBytesToString(bytesSample,"[privateKey here]","[passphrase here]");

}

```

### Verify methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.verify("text signed","text","[publicKey here]");
    var result = await OpenPGP.verifyBytes("text signed", bytesSample,"[publicKey here]");
    
    // verify signed with data
    var result = await OpenPGP.verifyData("text signed","[publicKey here]");
    var result = await OpenPGP.verifyDataBytes(bytesSample,"[publicKey here]");

}

```

### Encode methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.armorEncode(bytesSample);
}

```


### Metadata methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var result = await OpenPGP.getPrivateKeyMetadata("[privateKey here]");
    var result = await OpenPGP.getPublicKeyMetadata("[publicKey here]");
}

```


### Convert methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {
    var result = await OpenPGP.convertPrivateKeyToPublicKey("[privateKey here]");
}

```

## Setup

### Android

No additional setup required.

### iOS

No additional setup required.

### Web

Add to you `pubspec.yaml`.

```yaml
assets:
    - packages/openpgp/web/assets/worker.js
    - packages/openpgp/web/assets/wasm_exec.js
    - packages/openpgp/web/assets/openpgp.wasm
```

ref: https://github.com/jerson/flutter-openpgp/blob/master/example/pubspec.yaml

### MacOS

No additional setup required.

### Linux

No additional setup required.

### Windows

No additional setup required.

## Example

Inside example folder.

```bash
cd example && flutter run
```

check our web demo: [https://flutter-openpgp.jerson.dev/]

## Native Code

Native library is made in `Go` for faster performance.

[https://github.com/jerson/openpgp-mobile]

## Upgrade Library

You need to run 
```bash
make upgrade
```

## Tests

You need to run 
```bash
make test
```
