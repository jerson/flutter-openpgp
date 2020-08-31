import "dart:ffi" as ffi;
import 'dart:io' show Platform;
import "package:path/path.dart" show join;
import 'dart:io';

ffi.DynamicLibrary _dlopenPlatformSpecific(String name, {String path}) {
  String fullPath = _platformPath(name, path: path);
  return ffi.DynamicLibrary.open(fullPath);
}

String _platformPath(String name, {String path = ''}) {
  if (Platform.isMacOS) {
    return path + "darwin" + name + ".dylib";
  }
  if (Platform.isLinux || Platform.isAndroid) {
    // return path + name + "_linux_amd64.so";
    return '/home/gerson/Proyectos/go/openpgp-mobile/output/binding/openpgp.so';
  }
  if (Platform.isWindows) {
    return path + name + ".dll";
  }
  throw Exception("Platform not implemented");
}

ffi.DynamicLibrary openLib() {
  return _dlopenPlatformSpecific('openpgp',
      path: join(
        // Directory(Platform.resolvedExecutable).parent.path,
        '/home/gerson/Proyectos/flutter/flutter-openpgp/'
        'assets/binding/',
      ));
}
