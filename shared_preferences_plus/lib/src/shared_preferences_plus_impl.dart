import 'package:flutter/foundation.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// Dart wrapper around the platform implementation of shared preferences.
class SharedPreferencesPlus {
  /// Returns the active platform implementation.
  static SharedPreferencesPlusPlatform get _platform => SharedPreferencesPlusPlatform.instance;

  /// Options that control the underlying preferences namespace.
  final SharedPreferencesPlusOptions options;

  /// Creates a wrapper instance using the provided [options].
  SharedPreferencesPlus({this.options = const SharedPreferencesPlusOptions()});

  /// Stores a string value under [key].
  Future<void> setString(String key, String value) {
    return _platform.setString(key, value, options: options);
  }

  /// Returns the string stored for [key], or `null` if not present.
  Future<String?> getString(String key) {
    return _platform.getString(key, options: options);
  }

  /// Stores an integer value under [key].
  Future<void> setInt(String key, int value) {
    return _platform.setInt(key, value, options: options);
  }

  /// Returns the integer stored for [key], or `null` if not present.
  Future<int?> getInt(String key) {
    return _platform.getInt(key, options: options);
  }

  /// Stores a double value under [key].
  Future<void> setDouble(String key, double value) {
    return _platform.setDouble(key, value, options: options);
  }

  /// Returns the double stored for [key], or `null` if not present.
  Future<double?> getDouble(String key) {
    return _platform.getDouble(key, options: options);
  }

  /// Stores a boolean value under [key].
  Future<void> setBool(String key, bool value) {
    return _platform.setBool(key, value, options: options);
  }

  /// Returns the boolean stored for [key], or `null` if not present.
  Future<bool?> getBool(String key) {
    return _platform.getBool(key, options: options);
  }

  /// Stores a list of strings under [key].
  Future<void> setStringList(String key, List<String> value) {
    return _platform.setStringList(key, value, options: options);
  }

  /// Returns the string list stored for [key], or `null` if not present.
  Future<List<String>?> getStringList(String key) {
    return _platform.getStringList(key, options: options);
  }

  /// Removes the value stored for [key], if any.
  Future<void> remove(String key) {
    return _platform.remove(key, options: options);
  }

  /// Clears all stored preferences for this [options] namespace.
  Future<void> clear() {
    return _platform.clear(options: options);
  }

  /// Returns `true` if [key] exists.
  Future<bool> containsKey(String key) {
    return _platform.containsKey(key, options: options);
  }

  /// Returns the set of all keys stored in this preferences namespace.
  Future<Set<String>> getKeys() {
    return _platform.getKeys(options: options);
  }

  @visibleForTesting
  static void setMockInitialValues(
    Map<String, Object?> values, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    SharedPreferencesPlusPlatform.instance = InMemorySharedPreferencesPlusPlatform.withData(
      values,
      name: options.name,
    );
  }
}
