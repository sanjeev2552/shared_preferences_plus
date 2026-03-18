package com.example.shared_preferences_plus_android

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.core.content.edit

class SharedPreferencesPlusApiHandler(private val context: Context) : SharedPreferencesPlusApi {
    companion object {
        private const val TAG = "SharedPreferencesPlusAp"
    }

    private fun getPreferences(options: SharedPreferencesPlusPigeonOptions): SharedPreferences {
        return context.getSharedPreferences(options.name, Context.MODE_PRIVATE)
    }

    private fun getPreferencesEditor(
        options: SharedPreferencesPlusPigeonOptions, action: SharedPreferences.Editor.() -> Unit
    ) {
        getPreferences(options).edit {
            action()
        }
    }

    override fun setString(
        key: String, value: String, options: SharedPreferencesPlusPigeonOptions
    ) {
        Log.d(TAG, "setString: $key $value ${options.name}")
        getPreferencesEditor(options) {
            putString(key, value)
        }
    }

    override fun getString(
        key: String, options: SharedPreferencesPlusPigeonOptions
    ): String? {
        Log.d(TAG, "getString: $key ${options.name}")
        return getPreferences(options).getString(key, null)
    }
}