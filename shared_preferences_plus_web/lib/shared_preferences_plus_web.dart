import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences_plus_platform_interface/preferences_codec.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Web preferences backed by explicitly typed, versioned localStorage values.
class SharedPreferencesPlusWeb extends SharedPreferencesPlusPlatform {
  /// Creates an implementation with optional injectable storage.
  SharedPreferencesPlusWeb({PreferencesWebStorage? storage})
    : _storage = storage ?? BrowserPreferencesWebStorage();
  final PreferencesWebStorage _storage;
  String _name(SharedPreferencesPlusOptions options) => options.storageName;

  /// Registers this implementation.
  static void registerWith(Registrar registrar) {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWeb();
  }

  T _access<T>(T Function() operation) {
    try {
      return operation();
    } catch (error) {
      if (error is Error || error is Exception) rethrow;
      final jsError = error as JSAny;
      if (!jsError.isA<web.DOMException>()) rethrow;
      final exception = jsError as web.DOMException;
      throw PlatformException(
        code: exception.name == 'QuotaExceededError'
            ? 'storage-full'
            : 'storage-unavailable',
        message:
            'Browser preferences storage is unavailable (${exception.name}).',
      );
    }
  }

  DecodedPreferences _read(SharedPreferencesPlusOptions options) {
    final value = _access(() => _storage.read(_name(options)));
    return value == null
        ? DecodedPreferences({}, {})
        : PreferencesCodec.decodeData(value);
  }

  void _write(SharedPreferencesPlusOptions options, DecodedPreferences data) {
    final encoded = PreferencesCodec.encode(data.values, types: data.types);
    _access(() => _storage.write(_name(options), encoded));
  }

  Future<void> _set(
    String key,
    Object value,
    String type,
    SharedPreferencesPlusOptions options,
  ) async {
    final data = _read(options);
    data.values[key] = value;
    data.types[key] = type;
    _write(options, data);
  }

  Object? _get(String key, String type, SharedPreferencesPlusOptions options) {
    final data = _read(options);
    return data.types[key] == type ? data.values[key] : null;
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, 'string', options);
  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    if (value < -9007199254740991 || value > 9007199254740991) {
      throw ArgumentError.value(
        value,
        'value',
        'Web integers must be within the JavaScript safe integer range',
      );
    }
    await _set(key, value, 'int', options);
  }

  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, 'double', options);
  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, 'bool', options);
  @override
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, List<String>.from(value), 'list', options);
  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _get(key, 'string', options) as String?;
  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _get(key, 'int', options) as int?;
  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _get(key, 'double', options) as double?;
  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _get(key, 'bool', options) as bool?;
  @override
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _get(key, 'list', options) as List<String>?;
  @override
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final data = _read(options);
    data.values.remove(key);
    data.types.remove(key);
    _write(options, data);
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _access(() => _storage.remove(_name(options)));
  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _read(options).values.containsKey(key);
  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _read(options).values.keys.toSet();
  @override
  Future<PreferencesSnapshot> getSnapshot({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _read(options);
  @override
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => _read(options).values;
}

/// Minimal injectable browser storage contract.
abstract interface class PreferencesWebStorage {
  /// Reads a container.
  String? read(String name);

  /// Replaces a container.
  void write(String name, String value);

  /// Deletes a container.
  void remove(String name);
}

/// Accesses localStorage lazily so unavailable storage fails through operation Futures.
class BrowserPreferencesWebStorage implements PreferencesWebStorage {
  @override
  String? read(String name) => web.window.localStorage.getItem(name);
  @override
  void write(String name, String value) =>
      web.window.localStorage.setItem(name, value);
  @override
  void remove(String name) => web.window.localStorage.removeItem(name);
}
