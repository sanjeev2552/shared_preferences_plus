package com.example.shared_preferences_plus_android

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.core.content.edit

class SharedPreferencesPlusApiHandler(private val context: Context) : SharedPreferencesPlusApi {
    companion object {
        private const val TAG = "SharedPreferencesPlusAp"
        private const val stringSeparator = "/0001u"
    }

    private fun decodeStringList(value: String): List<String>? {
        return if (value.contains(stringSeparator)) {
            value.split(stringSeparator)
        } else {
            null
        }
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
        val prefs = getPreferences(options)
        if (!prefs.contains(key)) {
            return null
        }
        return try {
            prefs.getString(key, null)
        } catch (exception: ClassCastException) {
            null
        }
    }

    override fun setInt(
        key: String, value: Long, options: SharedPreferencesPlusPigeonOptions
    ) {
        Log.d(TAG, "setInt: $key $value ${options.name}")
        getPreferencesEditor(options) {
            putLong(key, value)
        }
    }

    override fun getInt(
        key: String, options: SharedPreferencesPlusPigeonOptions
    ): Long? {
        Log.d(TAG, "getInt: $key ${options.name}")
        val prefs = getPreferences(options)
        if (!prefs.contains(key)) {
            return null
        }
        return try {
            prefs.getLong(key, 0L)
        } catch (exception: ClassCastException) {
            null
        }
    }

    override fun setDouble(
        key: String, value: Double, options: SharedPreferencesPlusPigeonOptions
    ) {
        Log.d(TAG, "setDouble: $key $value ${options.name}")
        getPreferencesEditor(options) {
            putFloat(key, value.toFloat())
        }
    }

    override fun getDouble(
        key: String, options: SharedPreferencesPlusPigeonOptions
    ): Double? {
        Log.d(TAG, "getDouble: $key ${options.name}")
        val prefs = getPreferences(options)
        if (!prefs.contains(key)) {
            return null
        }
        return try {
            prefs.getFloat(key, 0.0f).toDouble()
        } catch (exception: ClassCastException) {
            null
        }
    }

    override fun setBool(
        key: String, value: Boolean, options: SharedPreferencesPlusPigeonOptions
    ) {
        Log.d(TAG, "setBool: $key $value ${options.name}")
        getPreferencesEditor(options) {
            putBoolean(key, value)
        }
    }

    override fun getBool(
        key: String, options: SharedPreferencesPlusPigeonOptions
    ): Boolean? {
        Log.d(TAG, "getBool: $key ${options.name}")
        val prefs = getPreferences(options)
        if (!prefs.contains(key)) {
            return null
        }
        return try {
            prefs.getBoolean(key, false)
        } catch (exception: ClassCastException) {
            null
        }
    }

    override fun setStringList(
        key: String, value: List<String>, options: SharedPreferencesPlusPigeonOptions
    ) {
        Log.d(TAG, "setStringList: $key ${options.name}")
        getPreferencesEditor(options) {
            putString(key, value.joinToString(stringSeparator))
        }
    }

    override fun getStringList(
        key: String, options: SharedPreferencesPlusPigeonOptions
    ): List<String>? {
        Log.d(TAG, "getStringList: $key ${options.name}")
        val prefs = getPreferences(options)
        if (!prefs.contains(key)) {
            return null
        }
        return try {
            val string = prefs.getString(key, null)
            if (string != null && string.isNotEmpty()) {
                string.split(stringSeparator).toList()
            } else {
                null
            }
        } catch (exception: ClassCastException) {
            null
        }
    }

    override fun remove(key: String, options: SharedPreferencesPlusPigeonOptions) {
        Log.d(TAG, "remove: $key ${options.name}")
        getPreferencesEditor(options) {
            remove(key)
        }
    }

    override fun clear(options: SharedPreferencesPlusPigeonOptions) {
        Log.d(TAG, "clear: ${options.name}")
        getPreferencesEditor(options) {
            clear()
        }
    }

    override fun containsKey(key: String, options: SharedPreferencesPlusPigeonOptions): Boolean {
        return getPreferences(options).contains(key)
    }

    override fun getKeys(options: SharedPreferencesPlusPigeonOptions): List<String> {
        return getPreferences(options).all.keys.toList()
    }

    override fun getAll(options: SharedPreferencesPlusPigeonOptions): Map<String, Any?> {
        val prefs = getPreferences(options)
        val all = prefs.all
        val result = mutableMapOf<String, Any?>()
        for ((key, value) in all) {
            when (value) {
                null -> {}
                is String -> {
                    val decoded = decodeStringList(value)
                    result[key] = decoded ?: value
                }
                is Int -> result[key] = value.toLong()
                is Long -> result[key] = value
                is Float -> result[key] = value.toDouble()
                is Boolean -> result[key] = value
                is Set<*> -> {
                    val strings = value.filterIsInstance<String>()
                    if (strings.size == value.size) {
                        result[key] = strings
                    }
                }
            }
        }
        return result
    }
}
