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
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setString', _argsWithOptions(options, key: key, value: value));
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<String>('getString', _argsWithOptions(options, key: key));
  }

  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setInt', _argsWithOptions(options, key: key, value: value));
  }

  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getInt', _argsWithOptions(options, key: key));
    return value is int ? value : null;
  }

  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setDouble', _argsWithOptions(options, key: key, value: value));
  }

  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getDouble', _argsWithOptions(options, key: key));
    return value is double ? value : null;
  }

  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setBool', _argsWithOptions(options, key: key, value: value));
  }

  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('getBool', _argsWithOptions(options, key: key));
    return value is bool ? value : null;
  }

  @override
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
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('remove', _argsWithOptions(options, key: key));
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('clear', _argsWithOptions(options));
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value =
        await methodChannel.invokeMethod<Object?>('containsKey', _argsWithOptions(options, key: key));
    return value is bool ? value : false;
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await methodChannel.invokeMethod<Object?>('getKeys', _argsWithOptions(options));
    if (value is List && value.every((Object? item) => item is String)) {
      return value.cast<String>().toSet();
    }
    return <String>{};
  }
}
