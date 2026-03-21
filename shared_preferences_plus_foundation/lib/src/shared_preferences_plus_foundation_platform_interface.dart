import 'package:shared_preferences_plus_foundation/src/messages.g.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class SharedPreferencesPlusFoundation extends SharedPreferencesPlusPlatform {
  final SharedPreferencesPlusApi _api;

  SharedPreferencesPlusFoundation({SharedPreferencesPlusApi? api})
    : _api =
          api ??
          SharedPreferencesPlusApi(messageChannelSuffix: 'shared_preferences_plus_foundation');

  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusFoundation();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return _api.getString(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
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
  }) {
    return _api.getInt(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
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
  }) {
    return _api.getStringList(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
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
    return Map<String, Object>.fromEntries(
      all.entries
          .where((MapEntry<String, Object?> entry) => entry.value != null)
          .map(
            (MapEntry<String, Object?> entry) => MapEntry<String, Object>(entry.key, entry.value!),
          ),
    );
  }
}
