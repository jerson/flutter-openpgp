import 'package:openpgp/key_options.dart';

class Options {
  final String comment;
  final String email;
  final String name;
  final String passphrase;
  final KeyOptions keyOptions;

  Options({
    this.comment,
    this.email,
    this.name,
    this.passphrase,
    this.keyOptions,
  });
}
