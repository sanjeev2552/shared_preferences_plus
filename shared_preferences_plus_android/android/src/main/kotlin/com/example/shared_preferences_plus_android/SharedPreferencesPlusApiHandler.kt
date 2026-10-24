package com.example.shared_preferences_plus_android

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

/** Typed storage. Legacy delimiter lists are decoded only for untagged values. */
class SharedPreferencesPlusApiHandler(private val context: Context) : SharedPreferencesPlusApi {
    companion object {
        private const val VERSION = "shared_preferences_plus/1"
        private const val LEGACY_SEPARATOR = "/0001u"
    }

    private fun preferences(options: SharedPreferencesPlusPigeonOptions): SharedPreferences =
        context.getSharedPreferences(options.name, Context.MODE_PRIVATE)

    // A StringSet is distinct from every value written by earlier plugin versions.
    // Both marker and payload live in one preference, so writes are atomic per key.
    private fun typed(type: String, value: Any): Set<String> = setOf(
        VERSION, JSONObject().put("type", type).put("value", value).toString()
    )

    private fun decode(value: Any?): Any? = when (value) {
        is Set<*> -> if (value.size == 2 && value.contains(VERSION)) {
            val payload = JSONObject(value.first { it != VERSION } as String)
            when (payload.getString("type")) {
                "string" -> payload.getString("value")
                "double" -> payload.getString("value").toDouble()
                "list" -> payload.getJSONArray("value").let { array ->
                    List(array.length()) { array.getString(it) }
                }
                else -> throw IllegalStateException("Unsupported preference encoding")
            }
        } else {
            value.map { it as String }
        }
        is String -> if (value.contains(LEGACY_SEPARATOR)) value.split(LEGACY_SEPARATOR) else value
        is Float -> value.toDouble()
        is Int -> value.toLong()
        else -> value
    }

    private fun value(key: String, options: SharedPreferencesPlusPigeonOptions): Any? =
        decode(preferences(options).all[key])

    private fun edit(options: SharedPreferencesPlusPigeonOptions, action: SharedPreferences.Editor.() -> Unit) {
        val editor = preferences(options).edit()
        editor.action()
        // SharedPreferences apply() updates process memory immediately; disk flush is asynchronous.
        editor.apply()
    }

    override fun setString(key: String, value: String, options: SharedPreferencesPlusPigeonOptions) =
        edit(options) { putStringSet(key, typed("string", value)) }
    override fun getString(key: String, options: SharedPreferencesPlusPigeonOptions): String? =
        (preferences(options).all[key] as? String) ?: (value(key, options) as? String)
    override fun setInt(key: String, value: Long, options: SharedPreferencesPlusPigeonOptions) = edit(options) { putLong(key, value) }
    override fun getInt(key: String, options: SharedPreferencesPlusPigeonOptions): Long? = value(key, options) as? Long
    override fun setDouble(key: String, value: Double, options: SharedPreferencesPlusPigeonOptions) =
        edit(options) { putStringSet(key, typed("double", value.toString())) }
    override fun getDouble(key: String, options: SharedPreferencesPlusPigeonOptions): Double? = value(key, options) as? Double
    override fun setBool(key: String, value: Boolean, options: SharedPreferencesPlusPigeonOptions) = edit(options) { putBoolean(key, value) }
    override fun getBool(key: String, options: SharedPreferencesPlusPigeonOptions): Boolean? = value(key, options) as? Boolean
    override fun setStringList(key: String, value: List<String>, options: SharedPreferencesPlusPigeonOptions) =
        edit(options) { putStringSet(key, typed("list", JSONArray(value))) }
    override fun getStringList(key: String, options: SharedPreferencesPlusPigeonOptions): List<String>? {
        val raw = preferences(options).all[key]
        // Explicit typed reads can recover legacy single-item lists. Empty legacy
        // strings cannot distinguish [] from [""]; preserve their old null behavior.
        if (raw is String) return if (raw.isEmpty()) null else raw.split(LEGACY_SEPARATOR)
        @Suppress("UNCHECKED_CAST")
        return decode(raw) as? List<String>
    }
    override fun remove(key: String, options: SharedPreferencesPlusPigeonOptions) = edit(options) { remove(key) }
    override fun clear(options: SharedPreferencesPlusPigeonOptions) = edit(options) { clear() }
    override fun containsKey(key: String, options: SharedPreferencesPlusPigeonOptions): Boolean = preferences(options).contains(key)
    override fun getKeys(options: SharedPreferencesPlusPigeonOptions): List<String> = preferences(options).all.keys.toList()
    override fun getAll(options: SharedPreferencesPlusPigeonOptions): Map<String, Any?> = preferences(options).all.mapValues { decode(it.value) }
}
