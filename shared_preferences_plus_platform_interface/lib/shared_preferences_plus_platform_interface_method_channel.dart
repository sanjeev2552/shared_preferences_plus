import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

import 'shared_preferences_plus_platform_interface_platform_interface.dart';

/// An implementation of [SharedPreferencesPlusPlatform] that uses method channels.
class MethodChannelSharedPreferencesPlusPlatformInterface extends SharedPreferencesPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shared_preferences_plus_platform_interface');

  Map<String, Object?> _argsWithOptions(
    SharedPreferencesPlusOptions options, {
    String? key,
    Object? value,
  }) {
    final Map<String, Object?> args = <String, Object?>{'options': options.name};
    if (key != null) {
      args['key'] = key;
    }
    if (value != null) {
      args['value'] = value;
    }
    return args;
  }

  @override
  /// Persists a string [value] for [key].
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setString', _argsWithOptions(options, key: key, value: value));
  }

  @override
  /// Reads a string value for [key].
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<String>('getString', _argsWithOptions(options, key: key));
  }

  @override
  /// Persists an integer [value] for [key].
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setInt', _argsWithOptions(options, key: key, value: value));
  }

  @override
  /// Reads an integer value for [key].
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getInt', _argsWithOptions(options, key: key));
    return value is int ? value : null;
  }

  @override
  /// Persists a double [value] for [key].
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setDouble', _argsWithOptions(options, key: key, value: value));
  }

  @override
  /// Reads a double value for [key].
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getDouble', _argsWithOptions(options, key: key));
    return value is double ? value : null;
  }

  @override
  /// Persists a boolean [value] for [key].
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setBool', _argsWithOptions(options, key: key, value: value));
  }

  @override
  /// Reads a boolean value for [key].
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getBool', _argsWithOptions(options, key: key));
    return value is bool ? value : null;
  }

  @override
  /// Persists a string list [value] for [key].
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>(
      'setStringList',
      _argsWithOptions(options, key: key, value: value),
    );
  }

  @override
  /// Reads a string list for [key].
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getStringList', _argsWithOptions(options, key: key));
    if (value is List) {
      if (value.every((Object? item) => item is String)) {
        return value.cast<String>();
      }
    }
    return null;
  }

  @override
  /// Removes the preference for [key].
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('remove', _argsWithOptions(options, key: key));
  }

  @override
  /// Clears all preferences for the configured [options].
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('clear', _argsWithOptions(options));
  }

  @override
  /// Returns whether a value exists for [key].
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('containsKey', _argsWithOptions(options, key: key));
    return value is bool ? value : false;
  }

  @override
  /// Returns all stored keys for the configured [options].
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await methodChannel.invokeMethod<Object?>('getKeys', _argsWithOptions(options));
    if (value is List && value.every((Object? item) => item is String)) {
      return value.cast<String>().toSet();
    }
    return <String>{};
  }

  @override
  /// Returns all stored key-value pairs for the configured [options].
  Future<Map<String, Object>> getAll({SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()}) {
    return methodChannel.invokeMethod<Map<Object?, Object>>('getAll', _argsWithOptions(options)).then((value) {
      if (value == null) {
        return <String, Object>{};
      }
      final Map<String, Object> result = {};
      value.forEach((Object? key, Object? value) {
        if (key is String && value != null) {
          if (value is List && value.every((Object? item) => item is String)) {
            result[key] = value.cast<String>();
          } else {
            result[key] = value;
          }
        }
      });
      return result;
    });
  }
}
