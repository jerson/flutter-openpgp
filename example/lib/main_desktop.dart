import 'main.dart' as original_main;
import 'package:openpgp/openpgp.dart';

// This file is the default main entry-point for go-flutter application.
void main() {
  OpenPGP.bindingEnabled = false;
  original_main.main();
}
