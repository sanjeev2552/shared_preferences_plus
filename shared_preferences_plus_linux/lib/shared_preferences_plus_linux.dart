import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';
import 'package:shared_preferences_plus_linux/file_util.dart';

/// Linux implementation of [SharedPreferencesPlusPlatform].
///
/// Uses a filesystem-backed store to persist preferences.
class SharedPreferencesPlusLinux extends SharedPreferencesPlusPlatform {
  /// Creates a Linux-backed shared preferences implementation.
  SharedPreferencesPlusLinux();

  /// Registers this implementation as the default platform instance.
  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusLinux();
  }

  Future<Map<String, Object?>> _readPreferences(SharedPreferencesPlusOptions options) {
    return FileUtil.readPreferences(options);
  }

  Future<void> _writePreferences(
    SharedPreferencesPlusOptions options,
    Map<String, Object?> preferences,
  ) {
    return FileUtil.writePreferences(options, preferences);
  }

  @override
  /// Reads a string value for [key].
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is String ? value : null;
  }

  @override
  /// Persists a string [value] for [key].
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData[key] = value;
    await _writePreferences(options, jsonData);
  }

  @override
  /// Persists an integer [value] for [key].
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData[key] = value;
    await _writePreferences(options, jsonData);
  }

  @override
  /// Reads an integer value for [key].
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is int ? value : null;
  }

  @override
  /// Persists a double [value] for [key].
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData[key] = value;
    await _writePreferences(options, jsonData);
  }

  @override
  /// Reads a double value for [key].
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is double ? value : null;
  }

  @override
  /// Persists a boolean [value] for [key].
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData[key] = value;
    await _writePreferences(options, jsonData);
  }

  @override
  /// Reads a boolean value for [key].
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is bool ? value : null;
  }

  @override
  /// Persists a string list [value] for [key].
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData[key] = value;
    await _writePreferences(options, jsonData);
  }

  @override
  /// Reads a string list for [key].
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    if (value is List && value.every((Object? item) => item is String)) {
      return value.cast<String>();
    }
    return null;
  }

  @override
  /// Removes the preference for [key].
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData.remove(key);
    await _writePreferences(options, jsonData);
  }

  @override
  /// Clears all preferences for the configured [options].
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    await _writePreferences(options, <String, Object?>{});
  }

  @override
  /// Returns whether a value exists for [key].
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    return jsonData.containsKey(key);
  }

  @override
  /// Returns all stored keys for the configured [options].
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    return jsonData.keys.toSet();
  }

  @override
  /// Returns all stored key-value pairs for the configured [options].
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Map<String, Object> result = {};
    for (final MapEntry<String, Object?> entry in jsonData.entries) {
      final Object? value = entry.value;
      if (value == null) {
        continue;
      }
      if (value is List && value.every((Object? item) => item is String)) {
        result[entry.key] = value.cast<String>();
        continue;
      }
      result[entry.key] = value;
    }
    return result;
  }
}
