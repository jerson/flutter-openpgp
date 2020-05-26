package dev.jerson.openpgp;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.HashMap;

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
    private Handler handler;

    // @irasekh3 - A private static function to properly instantiate OpenpgpPlugin
    //             if created as part of the the registration with 'registerWith'
    private static OpenpgpPlugin pluginFactory() {
        OpenpgpPlugin plugin = new OpenpgpPlugin();
        plugin.initialize();
        return plugin;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        initialize();
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "openpgp");
        channel.setMethodCallHandler(this);
    }

    private void initialize(){
        instance = Openpgp.newFastOpenPGP();
        handler = new Handler(Looper.getMainLooper());
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
        channel.setMethodCallHandler(pluginFactory());
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

            case "decryptBytes":
                decryptBytes(
                        (byte[]) call.argument("message"),
                        (String) call.argument("privateKey"),
                        (String) call.argument("passphrase"),
                        result
                );
                break;

            case "encryptBytes":
                encryptBytes(
                        (String) call.argument("message"),
                        (String) call.argument("publicKey"),
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
                        (HashMap<String, Object>) call.argument("options"),
                        result
                );
                break;
            case "encryptSymmetric":
                encryptSymmetric(
                        (String) call.argument("message"),
                        (String) call.argument("passphrase"),
                        (HashMap<String, Object>) call.argument("options"),
                        result
                );
                break;
            case "generate":
                generate(
                        (HashMap<String, Object>) call.argument("options"),
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

    private void success(final Result promise, final Object result) {
        Runnable local = new Runnable() {
            @Override
            public void run() {
                promise.success(result);
            }
        };

        handler.post(local);
    }

    private void error(final Result promise, final String errorCode, final String errorMessage, final Object errorDetails) {
        Runnable local = new Runnable() {
            @Override
            public void run() {
                promise.error(errorCode, errorMessage, errorDetails);
            }
        };

        handler.post(local);
    }

    private void decrypt(final String message, final String privateKey, final String passphrase, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String result = instance.decrypt(message, privateKey, passphrase);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }


    private void encrypt(final String message, final String publicKey, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String result = instance.encrypt(message, publicKey);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }

    private void decryptBytes(final byte[] message, final String privateKey, final String passphrase, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String result = instance.decryptBytes(message, privateKey, passphrase);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }


    private void encryptBytes(final String message, final String publicKey, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    byte[] result = instance.encryptBytes(message, publicKey);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }



    private void sign(final String message, final String publicKey, final String privateKey, final String passphrase, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String result = instance.sign(message, publicKey, privateKey, passphrase);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }


    private void verify(final String signature, final String message, final String publicKey, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    Boolean result = instance.verify(signature, message, publicKey);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }

    private KeyOptions getKeyOptions(HashMap<String, Object> map) {
        KeyOptions options = new KeyOptions();

        if (map == null) {
            return options;
        }
        if (map.containsKey("cipher")) {
            options.setCipher((String) map.get("cipher"));
        }
        if (map.containsKey("compression")) {
            options.setCompression((String) map.get("compression"));
        }
        if (map.containsKey("hash")) {
            options.setHash((String) map.get("hash"));
        }
        if (map.containsKey("rsaBits")) {
            options.setRSABits((Integer) map.get("rsaBits"));
        }
        if (map.containsKey("compressionLevel")) {
            options.setCompressionLevel((Integer) map.get("compressionLevel"));
        }
        return options;
    }

    private Options getOptions(HashMap<String, Object> map) {
        Options options = new Options();

        if (map == null) {
            return options;
        }
        if (map.containsKey("comment")) {
            options.setComment((String) map.get("comment"));
        }
        if (map.containsKey("email")) {
            options.setEmail((String) map.get("email"));
        }
        if (map.containsKey("name")) {
            options.setName((String) map.get("name"));
        }
        if (map.containsKey("passphrase")) {
            options.setPassphrase((String) map.get("passphrase"));
        }
        if (map.containsKey("keyOptions")) {
            HashMap<String, Object> keyOptions = (HashMap<String, Object>) map.get("keyOptions");
            if (keyOptions != null) {
                options.setKeyOptions(this.getKeyOptions(keyOptions));
            }
        }

        return options;
    }

    private void decryptSymmetric(final String message, final String passphrase, final HashMap<String, Object> mapOptions, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    KeyOptions options = getKeyOptions(mapOptions);
                    String result = instance.decryptSymmetric(message, passphrase, options);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }

    private void encryptSymmetric(final String message, final String passphrase, final HashMap<String, Object> mapOptions, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    KeyOptions options = getKeyOptions(mapOptions);
                    String result = instance.encryptSymmetric(message, passphrase, options);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }

    private void generate(final HashMap<String, Object> mapOptions, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    Options options = getOptions(mapOptions);
                    KeyPair keyPair = instance.generate(options);
                    HashMap<String, Object> result = new HashMap<>();
                    result.put("publicKey", keyPair.getPublicKey());
                    result.put("privateKey", keyPair.getPrivateKey());
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }
}
