import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';
import 'package:shared_preferences_plus_windows/file_util.dart';

class SharedPreferencesPlusWindows extends SharedPreferencesPlusPlatform {
  SharedPreferencesPlusWindows();

  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWindows();
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
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is String ? value : null;
  }

  @override
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
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is int ? value : null;
  }

  @override
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
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is double ? value : null;
  }

  @override
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
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    final Object? value = jsonData[key];
    return value is bool ? value : null;
  }

  @override
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
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    jsonData.remove(key);
    await _writePreferences(options, jsonData);
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    await _writePreferences(options, <String, Object?>{});
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    return jsonData.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await _readPreferences(options);
    return jsonData.keys.toSet();
  }
}
