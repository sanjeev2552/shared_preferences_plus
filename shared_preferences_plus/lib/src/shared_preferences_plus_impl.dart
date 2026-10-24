import 'package:flutter/foundation.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/preferences_values.dart';
import 'package:shared_preferences_plus_platform_interface/serial_executor.dart';

/// Cached preferences for an isolated named container.
///
/// Reads are synchronous after [getInstance]. Mutations and reloads execute in
/// call order within an isolate. Use [reload] to observe external changes.
class SharedPreferencesPlus {
  SharedPreferencesPlus._(this.options);

  /// The namespace used by this instance.
  final SharedPreferencesPlusOptions options;
  static final _states = <String, _ContainerState>{};
  static SharedPreferencesPlusPlatform get _platform =>
      SharedPreferencesPlusPlatform.instance;
  static String _name(SharedPreferencesPlusOptions options) =>
      options.storageName;
  static _ContainerState _stateFor(SharedPreferencesPlusOptions options) =>
      _states.putIfAbsent(_name(options), _ContainerState.new);
  _ContainerState get _state => _stateFor(options);

  /// Loads the namespace. Overlapping initialization requests share one load.
  static Future<SharedPreferencesPlus> getInstance({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final state = _stateFor(options);
    final existing = state.loading;
    if (existing != null) return existing;
    final prefs = SharedPreferencesPlus._(options);
    final future = prefs.reload().then((_) => prefs);
    state.loading = future;
    // Observe failure without creating an unhandled secondary error future.
    future.then<void>(
      (_) {
        if (identical(state.loading, future)) state.loading = null;
      },
      onError: (Object error, StackTrace stack) {
        if (identical(state.loading, future)) state.loading = null;
      },
    );
    return future;
  }

  Map<String, Object> _cache() {
    final cache = _state.cache;
    if (cache == null) {
      throw StateError(
        'SharedPreferencesPlus cache not loaded for "${_name(options)}".',
      );
    }
    return cache;
  }

  Future<void> _write(
    String key,
    Object value,
    String type,
    Future<void> Function(SharedPreferencesPlusPlatform) persist,
  ) {
    final state = _state;
    final revision = state.revision;
    final platform = _platform;
    return state.executor.run(() async {
      await persist(platform);
      if (state.revision == revision && state.cache != null) {
        state.cache![key] = value;
        state.types[key] = type;
      }
    });
  }

  /// Persists a string, updating the cache only on success.
  Future<void> setString(String key, String value) => _write(
    key,
    value,
    'string',
    (p) => p.setString(key, value, options: options),
  );

  /// Returns a string, or null for a missing key or different type.
  String? getString(String key) {
    final value = _cache()[key];
    return _state.types[key] == 'string' ? value as String? : null;
  }

  /// Persists an integer.
  Future<void> setInt(String key, int value) =>
      _write(key, value, 'int', (p) => p.setInt(key, value, options: options));

  /// Returns an integer, or null for a missing key or different type.
  int? getInt(String key) {
    final value = _cache()[key];
    return _state.types[key] == 'int' ? value as int? : null;
  }

  /// Persists a double, preserving its type.
  Future<void> setDouble(String key, double value) => _write(
    key,
    value,
    'double',
    (p) => p.setDouble(key, value, options: options),
  );

  /// Returns a double, or null for a missing key or different type.
  double? getDouble(String key) {
    final value = _cache()[key];
    return _state.types[key] == 'double' ? value as double? : null;
  }

  /// Persists a boolean.
  Future<void> setBool(String key, bool value) => _write(
    key,
    value,
    'bool',
    (p) => p.setBool(key, value, options: options),
  );

  /// Returns a boolean, or null for a missing key or different type.
  bool? getBool(String key) {
    final value = _cache()[key];
    return _state.types[key] == 'bool' ? value as bool? : null;
  }

  /// Persists a snapshot of [value], independent of subsequent caller mutations.
  Future<void> setStringList(String key, List<String> value) {
    final snapshot = List<String>.from(value);
    return _write(
      key,
      snapshot,
      'list',
      (p) =>
          p.setStringList(key, List<String>.from(snapshot), options: options),
    );
  }

  /// Returns a detached list, or null for a missing key or different type.
  List<String>? getStringList(String key) {
    final value = _cache()[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  /// Removes a key after previous operations finish.
  Future<void> remove(String key) {
    final state = _state;
    final revision = state.revision;
    final platform = _platform;
    return state.executor.run(() async {
      await platform.remove(key, options: options);
      if (state.revision == revision) {
        state.cache?.remove(key);
        state.types.remove(key);
      }
    });
  }

  /// Clears only this container.
  Future<void> clear() {
    final state = _state;
    final revision = state.revision;
    final platform = _platform;
    return state.executor.run(() async {
      await platform.clear(options: options);
      if (state.revision == revision) {
        state.cache?.clear();
        state.types.clear();
      }
    });
  }

  /// Whether the cache contains a key.
  bool containsKey(String key) => _cache().containsKey(key);

  /// Returns a detached set of keys.
  Set<String> getKeys() => _cache().keys.toSet();

  /// Returns a detached snapshot, including copies of nested string lists.
  Map<String, Object> getAll() => copyPreferences(_cache());

  /// Reloads external values in call order with writes to this namespace.
  Future<void> reload() {
    final state = _state;
    final revision = state.revision;
    final platform = _platform;
    return state.executor.run(() async {
      final snapshot = await platform.getSnapshot(options: options);
      if (state.revision == revision) {
        state.cache = copyPreferences(snapshot.values);
        state.types = Map<String, String>.from(snapshot.types);
      }
    });
  }

  /// Invalidates the cache, including results of operations already in flight.
  /// Call [reload] before the next synchronous read.
  static void clearCache({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final state = _stateFor(options);
    state.revision++;
    state.cache = null;
    state.loading = null;
  }

  /// Seeds a mock namespace without retaining caller-owned mutable values.
  @visibleForTesting
  static void setMockInitialValues(
    Map<String, Object?> values, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final current = _platform;
    final mock = current is InMemorySharedPreferencesPlusPlatform
        ? current
        : InMemorySharedPreferencesPlusPlatform();
    mock.setInitialValues(values, name: options.name);
    SharedPreferencesPlusPlatform.instance = mock;
    final state = _stateFor(options);
    state.revision++;
    state.loading = null;
    state.cache = copyPreferences(values);
    state.types = PreferencesSnapshot.fromValues(values).types;
  }

  /// Clears all mock namespaces and cached state between tests.
  @visibleForTesting
  static void resetMockInitialValues() {
    for (final state in _states.values) {
      state.revision++;
      state.cache = null;
      state.loading = null;
    }
    SharedPreferencesPlusPlatform.instance =
        InMemorySharedPreferencesPlusPlatform();
  }
}

class _ContainerState {
  final executor = SerialExecutor();
  Map<String, Object>? cache;
  Map<String, String> types = {};
  Future<SharedPreferencesPlus>? loading;
  int revision = 0;
}
