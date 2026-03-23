import 'package:flutter/widgets.dart';
import 'package:shared_preferences_plus_android/src/messages.g.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// Android platform implementation of [SharedPreferencesPlusPlatform].
///
/// Delegates all preference operations to the generated Pigeon API and
/// registers itself with the shared platform interface.
class SharedPreferencesPlusAndroid extends SharedPreferencesPlusPlatform {
  final SharedPreferencesPlusApi _api;
  static const String _stringListSeparator = "/0001u";

  /// Creates an Android-backed shared preferences implementation.
  SharedPreferencesPlusAndroid({SharedPreferencesPlusApi? api})
    : _api =
          api ?? SharedPreferencesPlusApi(messageChannelSuffix: 'shared_preferences_plus_android');

  /// Registers this implementation as the default platform instance.
  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusAndroid();
  }

  @override
  /// Reads a string value for [key].
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Getting string: key=$key, options=${options.name}');
    return _api.getString(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Persists a string [value] for [key].
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Setting string: key=$key, value=$value, options=${options.name}');
    return _api.setString(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Persists an integer [value] for [key].
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setInt(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Reads an integer value for [key].
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await _api.getInt(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return value;
  }

  @override
  /// Persists a double [value] for [key].
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setDouble(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Reads a double value for [key].
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.getDouble(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Persists a boolean [value] for [key].
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setBool(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Reads a boolean value for [key].
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.getBool(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Persists a string list [value] for [key].
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setStringList(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Reads a string list for [key].
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await _api.getStringList(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return value;
  }

  @override
  /// Removes the preference for [key].
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.remove(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Clears all preferences for the configured [options].
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.clear(SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Returns whether a value exists for [key].
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.containsKey(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  /// Returns all stored keys for the configured [options].
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final keys = await _api.getKeys(SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return keys.toSet();
  }

  @override
  /// Returns all stored key-value pairs for the configured [options].
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final all = await _api.getAll(SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    final Map<String, Object> result = {};
    for (final MapEntry<String, Object?> entry in all.entries) {
      final Object? value = entry.value;
      if (value == null) {
        continue;
      }
      if (value is List && value.every((Object? item) => item is String)) {
        result[entry.key] = value.cast<String>();
        continue;
      }
      if (value is String && value.contains(_stringListSeparator)) {
        result[entry.key] = value.split(_stringListSeparator);
        continue;
      }
      result[entry.key] = value;
    }
    return result;
  }
}
