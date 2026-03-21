import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

/// Simple in-memory implementation intended for tests.
class InMemorySharedPreferencesPlusPlatform extends SharedPreferencesPlusPlatform {
  static InMemorySharedPreferencesPlusPlatform withData(
    Map<String, Object?> initialValues, {
    String? name,
  }) {
    _storeByName[name ?? 'SharedPreferencesPlus'] = initialValues;
    return InMemorySharedPreferencesPlusPlatform();
  }

  static final Map<String, Map<String, Object?>> _storeByName = <String, Map<String, Object?>>{};

  String _bucketName(SharedPreferencesPlusOptions options) {
    return options.name ?? 'SharedPreferencesPlus';
  }

  Map<String, Object?> _bucket(SharedPreferencesPlusOptions options) {
    final String name = _bucketName(options);
    return _storeByName.putIfAbsent(name, () => <String, Object?>{});
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options)[key] = value;
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = _bucket(options)[key];
    return value is String ? value : null;
  }

  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options)[key] = value;
  }

  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = _bucket(options)[key];
    return value is int ? value : null;
  }

  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options)[key] = value;
  }

  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = _bucket(options)[key];
    return value is double ? value : null;
  }

  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options)[key] = value;
  }

  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = _bucket(options)[key];
    return value is bool ? value : null;
  }

  @override
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options)[key] = List<String>.from(value);
  }

  @override
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = _bucket(options)[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  @override
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options).remove(key);
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _bucket(options).clear();
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    return _bucket(options).containsKey(key);
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    return _bucket(options).keys.toSet();
  }

  @override
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final bucket = _bucket(options);
    return Map<String, Object>.fromEntries(
      bucket.entries
          .where((MapEntry<String, Object?> entry) => entry.value != null)
          .map(
            (MapEntry<String, Object?> entry) => MapEntry<String, Object>(entry.key, entry.value!),
          ),
    );
  }
}
