package com.example.shared_preferences_plus_android

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** SharedPreferencesPlusAndroidPlugin */
class SharedPreferencesPlusAndroidPlugin : FlutterPlugin {
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
