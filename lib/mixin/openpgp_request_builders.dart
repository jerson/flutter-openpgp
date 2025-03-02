import 'package:openpgp/openpgp.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

mixin OpenPGPRequestBuilders {
  static model.KeyOptionsObjectBuilder? keyOptionsBuilder(KeyOptions? input) {
    model.KeyOptionsObjectBuilder? builder;
    if (input != null) {
      builder = model.KeyOptionsObjectBuilder(
        cipher: input.cipher != null
            ? model.Cipher.values[input.cipher!.index]
            : null,
        compression: input.compression != null
            ? model.Compression.values[input.compression!.index]
            : null,
        algorithm: input.algorithm != null
            ? model.Algorithm.values[input.algorithm!.index]
            : null,
        curve:
            input.curve != null ? model.Curve.values[input.curve!.index] : null,
        compressionLevel: input.compressionLevel ?? 0,
        hash: input.hash != null ? model.Hash.values[input.hash!.index] : null,
        rsaBits: input.rsaBits ?? 0,
      );
    }
    return builder;
  }

  static model.OptionsObjectBuilder? optionsBuilder(Options? input) {
    model.OptionsObjectBuilder? builder;
    if (input != null) {
      builder = model.OptionsObjectBuilder(
        passphrase: input.passphrase ?? "",
        comment: input.comment ?? "",
        email: input.email ?? "",
        name: input.name ?? "",
        keyOptions: keyOptionsBuilder(input.keyOptions),
      );
    }
    return builder;
  }

  static model.EntityObjectBuilder? entityBuilder(Entity? input) {
    model.EntityObjectBuilder? builder;
    if (input != null) {
      builder = model.EntityObjectBuilder(
        passphrase: input.passphrase ?? "",
        privateKey: input.privateKey ?? "",
        publicKey: input.publicKey ?? "",
      );
    }
    return builder;
  }

  static model.FileHintsObjectBuilder? fileHintsBuilder(FileHints? input) {
    model.FileHintsObjectBuilder? builder;
    if (input != null) {
      builder = model.FileHintsObjectBuilder(
        fileName: input.fileName ?? "",
        isBinary: input.isBinary ?? false,
        modTime: input.modTime ?? "",
      );
    }
    return builder;
  }
}
