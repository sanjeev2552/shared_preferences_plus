package com.example.shared_preferences_plus_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** SharedPreferencesPlusAndroidPlugin */
class SharedPreferencesPlusAndroidPlugin : FlutterPlugin {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val sharedPreferencesPlusApiHandler =
            SharedPreferencesPlusApiHandler(flutterPluginBinding.applicationContext)
        SharedPreferencesPlusApi.setUp(
            flutterPluginBinding.binaryMessenger,
            sharedPreferencesPlusApiHandler,
            "shared_preferences_plus_android"
        )
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        SharedPreferencesPlusApi.setUp(
            binding.binaryMessenger, null, "shared_preferences_plus_android"
        )
    }
}
