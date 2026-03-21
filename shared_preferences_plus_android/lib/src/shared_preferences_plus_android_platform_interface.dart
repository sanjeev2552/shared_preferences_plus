import 'package:flutter/widgets.dart';
import 'package:shared_preferences_plus_android/src/messages.g.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class SharedPreferencesPlusAndroid extends SharedPreferencesPlusPlatform {
  final SharedPreferencesPlusApi _api;
  static const String _stringListSeparator = "/0001u";

  SharedPreferencesPlusAndroid({SharedPreferencesPlusApi? api})
    : _api =
          api ?? SharedPreferencesPlusApi(messageChannelSuffix: 'shared_preferences_plus_android');

  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusAndroid();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Getting string: key=$key, options=${options.name}');
    return _api.getString(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Setting string: key=$key, value=$value, options=${options.name}');
    return _api.setString(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setInt(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await _api.getInt(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return value;
  }

  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setDouble(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.getDouble(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setBool(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.getBool(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.setStringList(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = await _api.getStringList(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return value;
  }

  @override
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.remove(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.clear(SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.containsKey(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final keys = await _api.getKeys(SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
    return keys.toSet();
  }

  @override
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
