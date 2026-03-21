import 'package:flutter/foundation.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// Dart wrapper around the platform implementation of shared preferences.
class SharedPreferencesPlus {
  /// Returns the active platform implementation.
  static SharedPreferencesPlusPlatform get _platform => SharedPreferencesPlusPlatform.instance;

  static final Map<String, Map<String, Object>> _cacheByName = <String, Map<String, Object>>{};

  /// Options that control the underlying preferences namespace.
  final SharedPreferencesPlusOptions options;

  /// Creates a wrapper instance using the provided [options].
  static Future<SharedPreferencesPlus> getInstance({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _load(options: options);
  }

  /// Creates a wrapper instance using the provided [options] without loading values into the cache.
  SharedPreferencesPlus._({this.options = const SharedPreferencesPlusOptions()});

  /// Stores a string value under [key].
  Future<void> setString(String key, String value) {
    return _platform.setString(key, value, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache[key] = value;
      }
    });
  }

  /// Returns the string stored for [key], or `null` if not present.
  String? getString(String key) {
    final value = _cache()[key];
    return value is String ? value : null;
  }

  /// Stores an integer value under [key].
  Future<void> setInt(String key, int value) {
    return _platform.setInt(key, value, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache[key] = value;
      }
    });
  }

  /// Returns the integer stored for [key], or `null` if not present.
  int? getInt(String key) {
    final value = _cache()[key];
    return value is int ? value : null;
  }

  /// Stores a double value under [key].
  Future<void> setDouble(String key, double value) {
    return _platform.setDouble(key, value, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache[key] = value;
      }
    });
  }

  /// Returns the double stored for [key], or `null` if not present.
  double? getDouble(String key) {
    final value = _cache()[key];
    return value is double ? value : null;
  }

  /// Stores a boolean value under [key].
  Future<void> setBool(String key, bool value) {
    return _platform.setBool(key, value, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache[key] = value;
      }
    });
  }

  /// Returns the boolean stored for [key], or `null` if not present.
  bool? getBool(String key) {
    final value = _cache()[key];
    return value is bool ? value : null;
  }

  /// Stores a list of strings under [key].
  Future<void> setStringList(String key, List<String> value) {
    return _platform.setStringList(key, value, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache[key] = List<String>.from(value);
      }
    });
  }

  /// Returns the string list stored for [key], or `null` if not present.
  List<String>? getStringList(String key) {
    final value = _cache()[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  /// Removes the value stored for [key], if any.
  Future<void> remove(String key) {
    return _platform.remove(key, options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache.remove(key);
      }
    });
  }

  /// Clears all stored preferences for this [options] namespace.
  Future<void> clear() {
    return _platform.clear(options: options).then((_) {
      final cache = _cacheForWrite();
      if (cache != null) {
        cache.clear();
      }
    });
  }

  /// Returns `true` if [key] exists.
  bool containsKey(String key) {
    return _cache().containsKey(key);
  }

  /// Returns the set of all keys stored in this preferences namespace.
  Set<String> getKeys() {
    return _cache().keys.toSet();
  }

  /// Returns all stored preferences for this [options] namespace.
  Map<String, Object> getAll() {
    return Map<String, Object>.from(_cache());
  }

  /// Loads preferences for the provided [options] into the shared cache.
  static Future<SharedPreferencesPlus> _load({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final String name = _bucketName(options);
    final Map<String, Object> values = await _platform.getAll(options: options);
    _cacheByName[name] = Map<String, Object>.from(values);
    return SharedPreferencesPlus._(options: options);
  }

  /// Reloads preferences for this [options] namespace into the shared cache.
  Future<void> reload() async {
    final Map<String, Object> values = await _platform.getAll(options: options);
    _cacheByName[_bucketName(options)] = Map<String, Object>.from(values);
  }

  /// Clears the shared cache for the provided [options].
  static void clearCache({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    _cacheByName.remove(_bucketName(options));
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
    _cacheByName[_bucketName(options)] = Map<String, Object>.fromEntries(
      values.entries
          .where((MapEntry<String, Object?> entry) => entry.value != null)
          .map(
            (MapEntry<String, Object?> entry) => MapEntry<String, Object>(entry.key, entry.value!),
          ),
    );
  }

  static String _bucketName(SharedPreferencesPlusOptions options) {
    return options.name ?? 'SharedPreferencesPlus';
  }

  Map<String, Object> _cache() {
    final String name = _bucketName(options);
    final Map<String, Object>? cache = _cacheByName[name];
    if (cache == null) {
      throw StateError('SharedPreferencesPlus cache not loaded for "$name".');
    }
    return cache;
  }

  Map<String, Object>? _cacheForWrite() {
    final String name = _bucketName(options);
    return _cacheByName[name];
  }
}
