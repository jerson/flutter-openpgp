# openpgp

This Go package implements the host-side of the Flutter [openpgp](https://github.com/jerson/flutter-openpgp) plugin.

## Usage

Import as:

```go
import openpgp "github.com/jerson/flutter-openpgp/go"
```

Then add the following option to your go-flutter [application options](https://github.com/go-flutter-desktop/go-flutter/wiki/Plugin-info):

```go
flutter.AddPlugin(&openpgp.Plugin{}),
```
