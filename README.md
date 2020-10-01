# OpenPGP

Library for use openPGP with support for android, ios, macos, windows, linux, web and hover

## Contents

- [Usage](#usage)
- [Setup](#setup)
  - [Android](#android)
    - [ProGuard](#proguard)
  - [iOS](#ios)
  - [Web](#web)
  - [MacOS](#macos)
  - [Hover](#hover)
  - [Linux](#linux)
  - [Windows](#windows)
- [Example](#example)
- [Native Code](#native-code)

## Usage

## Generate methods
```dart
import 'package:openpgp/openpgp.dart';

void main() async {
    var keyOptions = KeyOptions()..rsaBits = 1024;
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
    
    var result = await OpenPGP.sign("text","[publicKey here]","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.signBytesToString(bytesSample,"[publicKey here]","[privateKey here]","[passphrase here]");

}

```

### Verify methods

```dart
import 'package:fast_rsa/rsa.dart';

void main() async {

    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.verify("text signed","text","[publicKey here]");
    var result = await OpenPGP.verifyBytes("text signed", bytesSample,"[publicKey here]");

}

```

## Setup

### Android

#### ProGuard

Add this lines to `android/app/proguard-rules.pro` for proguard support.

```proguard
-keep class go.** { *; }
-keep class openpgp.** { *; }
```

### iOS

No additional setup required.

### Web

    Web support right now is half progress, we need for support web workers. in order to make async calls.

Add to you `pubspec.yaml`.

```yaml
assets:
  - packages/openpgp/web/assets/wasm_exec.js
  - packages/openpgp/web/assets/openpgp.wasm
```

ref: https://github.com/jerson/flutter-openpgp/blob/master/example/pubspec.yaml

and in you `web/index.html`

```html
<script
  src="assets/packages/openpgp/web/assets/wasm_exec.js"
  type="application/javascript"
></script>
```

ref: https://github.com/jerson/flutter-openpgp/blob/master/example/web/index.html

### MacOS

No additional setup required.

### Hover

Update your plugins.

```bash
hover plugins get
```

In you `main_desktop.dart` by now you need to add `OpenPGP.bindingEnabled = false` in order to use channels instead of shared objects

```dart
import 'main.dart' as original_main;
import 'package:openpgp/openpgp.dart';

void main() {
  OpenPGP.bindingEnabled = false;
  original_main.main();
}

```

### Linux

No additional setup required.

### Windows

Work in progress...

## Example

Inside example folder.

```bash
cd example && flutter run
```

## Native Code

Native library is made in `Go` for faster performance.

[https://github.com/jerson/openpgp-mobile]
