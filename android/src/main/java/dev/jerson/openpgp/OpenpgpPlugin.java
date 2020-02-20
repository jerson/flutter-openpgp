package dev.jerson.openpgp;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import openpgp.FastOpenPGP;
import openpgp.KeyOptions;
import openpgp.KeyPair;
import openpgp.Openpgp;
import openpgp.Options;

/**
 * OpenpgpPlugin
 */
public class OpenpgpPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private FastOpenPGP instance;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        instance = Openpgp.newFastOpenPGP();
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "openpgp");
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "openpgp");
        channel.setMethodCallHandler(new OpenpgpPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        switch (call.method) {
            case "decrypt":
                decrypt(
                        (String) call.argument("message"),
                        (String) call.argument("privateKey"),
                        (String) call.argument("passphrase"),
                        result
                );
                break;
            case "encrypt":
                encrypt(
                        (String) call.argument("message"),
                        (String) call.argument("publicKey"),
                        result
                );
                break;
            case "sign":
                sign(
                        (String) call.argument("message"),
                        (String) call.argument("publicKey"),
                        (String) call.argument("privateKey"),
                        (String) call.argument("passphrase"),
                        result
                );
                break;
            case "verify":
                verify(
                        (String) call.argument("signature"),
                        (String) call.argument("message"),
                        (String) call.argument("publicKey"),
                        result
                );
                break;
            case "decryptSymmetric":
                decryptSymmetric(
                        (String) call.argument("message"),
                        (String) call.argument("passphrase"),
                        call,
                        result
                );
                break;
            case "encryptSymmetric":
                encryptSymmetric(
                        (String) call.argument("message"),
                        (String) call.argument("passphrase"),
                        call,
                        result
                );
                break;
            case "generate":
                generate(
                        call,
                        result
                );
                break;
            default:
                result.notImplemented();
                break;
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    private void decrypt(String message, String privateKey, String passphrase, Result promise) {
        try {
            String result = instance.decrypt(message, privateKey, passphrase);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }


    private void encrypt(String message, String publicKey, Result promise) {
        try {
            String result = instance.encrypt(message, publicKey);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }


    private void sign(String message, String publicKey, String privateKey, String passphrase, Result promise) {
        try {
            String result = instance.sign(message, publicKey, privateKey, passphrase);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }


    private void verify(String signature, String message, String publicKey, Result promise) {
        try {
            Boolean result = instance.verify(signature, message, publicKey);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }

    private KeyOptions getKeyOptions(MethodCall map) {
        KeyOptions options = new KeyOptions();

        if (map == null) {
            return options;
        }
        if (map.hasArgument("cipher")) {
            options.setCipher((String) map.argument("cipher"));
        }
        if (map.hasArgument("compression")) {
            options.setCompression((String) map.argument("compression"));
        }
        if (map.hasArgument("hash")) {
            options.setHash((String) map.argument("hash"));
        }
        if (map.hasArgument("RSABits")) {
            options.setRSABits((Integer) map.argument("rsaBits"));
        }
        if (map.hasArgument("compressionLevel")) {
            options.setCompressionLevel((Integer) map.argument("compressionLevel"));
        }
        return options;
    }

    private Options getOptions(MethodCall map) {
        Options options = new Options();

        if (map == null) {
            return options;
        }
        if (map.hasArgument("comment")) {
            options.setComment((String) map.argument("comment"));
        }
        if (map.hasArgument("email")) {
            options.setEmail((String) map.argument("email"));
        }
        if (map.hasArgument("name")) {
            options.setName((String) map.argument("name"));
        }
        if (map.hasArgument("passphrase")) {
            options.setPassphrase((String) map.argument("passphrase"));
        }
        if (map.hasArgument("keyOptions")) {
            MethodCall keyOptions = map.argument("keyOptions");
            if (keyOptions != null) {
                options.setKeyOptions(this.getKeyOptions(keyOptions));
            }
        }

        return options;
    }

    private void decryptSymmetric(String message, String passphrase, MethodCall mapOptions, Result promise) {

        try {
            KeyOptions options = this.getKeyOptions(mapOptions);
            String result = instance.decryptSymmetric(message, passphrase, options);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }

    private void encryptSymmetric(String message, String passphrase, MethodCall mapOptions, Result promise) {
        try {
            KeyOptions options = this.getKeyOptions(mapOptions);
            String result = instance.encryptSymmetric(message, passphrase, options);
            promise.success(result);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }

    private void generate(MethodCall mapOptions, Result promise) {
        try {
            Options options = this.getOptions(mapOptions);
            KeyPair keyPair = instance.generate(options);
            promise.success(keyPair);
        } catch (Exception e) {
            promise.error("error", e.getMessage(), e);
        }
    }
}
