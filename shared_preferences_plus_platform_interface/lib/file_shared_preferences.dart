import 'file_preferences_store.dart';
import 'shared_preferences_plus_platform_interface.dart';

/// Common typed adapter for desktop file storage. This library uses dart:io and
/// is intentionally separate from the web-compatible platform-interface exports.
class FileSharedPreferencesPlatform extends SharedPreferencesPlusPlatform {
  /// Creates an adapter with an injectable store.
  FileSharedPreferencesPlatform(this.store);

  /// The transactional store used by this adapter.
  final FilePreferencesStore store;
  String _name(SharedPreferencesPlusOptions options) => options.storageName;
  Future<void> _set(
    String key,
    Object value,
    SharedPreferencesPlusOptions options,
  ) => store.update(_name(options), (values) {
    values[key] = value;
  });
  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, options);
  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, options);
  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, options);
  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, value, options);
  @override
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => _set(key, List<String>.from(value), options);
  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = (await getAll(options: options))[key];
    return value is String ? value : null;
  }

  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = (await getAll(options: options))[key];
    return value is int ? value : null;
  }

  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = (await getAll(options: options))[key];
    return value is double ? value : null;
  }

  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = (await getAll(options: options))[key];
    return value is bool ? value : null;
  }

  @override
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final value = (await getAll(options: options))[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  @override
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => store.update(_name(options), (values) {
    values.remove(key);
  });
  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => store.clear(_name(options));
  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => (await getAll(options: options)).containsKey(key);
  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async => (await getAll(options: options)).keys.toSet();
  @override
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) => store.read(_name(options));
}
