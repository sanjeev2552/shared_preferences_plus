import 'dart:convert';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Web-backed implementation of [SharedPreferencesPlusPlatform].
///
/// Stores preferences in `window.localStorage`.
class SharedPreferencesPlusWeb extends SharedPreferencesPlusPlatform {
  /// Creates a web shared preferences implementation.
  SharedPreferencesPlusWeb();

  Map<String, Object?> _readMap(SharedPreferencesPlusOptions options) {
    final currentValue = web.window.localStorage.getItem(options.name ?? '');
    if (currentValue == null) {
      return <String, Object?>{};
    }
    final Map<String, dynamic> decoded = jsonDecode(currentValue) as Map<String, dynamic>;
    return decoded;
  }

  void _writeMap(SharedPreferencesPlusOptions options, Map<String, Object?> map) {
    web.window.localStorage.setItem(options.name ?? '', jsonEncode(map));
  }

  /// Registers this implementation as the default platform instance.
  static void registerWith(Registrar registrar) {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWeb();
  }

  @override
  /// Reads a string value for [key].
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is String ? value : null);
  }

  @override
  /// Persists a string [value] for [key].
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded[key] = value;
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Persists an integer [value] for [key].
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded[key] = value;
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Reads an integer value for [key].
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is int ? value : null);
  }

  @override
  /// Persists a double [value] for [key].
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded[key] = value;
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Reads a double value for [key].
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is double ? value : null);
  }

  @override
  /// Persists a boolean [value] for [key].
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded[key] = value;
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Reads a boolean value for [key].
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is bool ? value : null);
  }

  @override
  /// Persists a string list [value] for [key].
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded[key] = value;
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Reads a string list for [key].
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    if (value is List && value.every((Object? item) => item is String)) {
      return Future.value(value.cast<String>());
    }
    return Future.value(null);
  }

  @override
  /// Removes the preference for [key].
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    decoded.remove(key);
    _writeMap(options, decoded);
    return Future.value();
  }

  @override
  /// Clears all preferences for the configured [options].
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    web.window.localStorage.removeItem(options.name ?? '');
    return Future.value();
  }

  @override
  /// Returns whether a value exists for [key].
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    return Future.value(decoded.containsKey(key));
  }

  @override
  /// Returns all stored keys for the configured [options].
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    return Future.value(decoded.keys.toSet());
  }

  @override
  /// Returns all stored key-value pairs for the configured [options].
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Map<String, Object> result = {};
    for (final MapEntry<String, Object?> entry in decoded.entries) {
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
    return Future.value(result);
  }
}
