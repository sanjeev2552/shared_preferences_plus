// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:web/web.dart' as web;

/// A web implementation of the SharedPreferencesPlusWebPlatform of the SharedPreferencesPlusWeb plugin.
class SharedPreferencesPlusWeb extends SharedPreferencesPlusPlatform {
  /// Constructs a SharedPreferencesPlusWebWeb
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

  static void registerWith(Registrar registrar) {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWeb();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is String ? value : null);
  }

  @override
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
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is int ? value : null);
  }

  @override
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
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is double ? value : null);
  }

  @override
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
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    final Object? value = decoded[key];
    return Future.value(value is bool ? value : null);
  }

  @override
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
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    web.window.localStorage.removeItem(options.name ?? '');
    return Future.value();
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    return Future.value(decoded.containsKey(key));
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final Map<String, Object?> decoded = _readMap(options);
    return Future.value(decoded.keys.toSet());
  }
}
