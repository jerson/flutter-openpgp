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
import openPGPBridge.OpenPGPBridge;
/**
 * OpenpgpPlugin
 */
public class OpenpgpPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
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
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "openpgp");
        channel.setMethodCallHandler(this);
    }

    private void initialize() {
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
        this.call(call.method, (byte[]) call.arguments, result);
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

    private void call(final String name, final byte[] payload, final Result promise) {
        new Thread(new Runnable() {
            public void run() {
                try {
                    byte[] result = OpenPGPBridge.call(name, payload);
                    success(promise, result);
                } catch (Exception e) {
                    error(promise, "error", e.getMessage(), null);
                }
            }
        }).start();
    }

}
