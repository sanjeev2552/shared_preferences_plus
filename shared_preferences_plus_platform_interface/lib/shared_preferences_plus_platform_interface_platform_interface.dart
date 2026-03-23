import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

import 'shared_preferences_plus_platform_interface_method_channel.dart';

/// Contract implemented by all platform-specific shared_preferences_plus plugins.
abstract class SharedPreferencesPlusPlatform extends PlatformInterface {
  /// Constructs a SharedPreferencesPlusPlatformInterfacePlatform.
  SharedPreferencesPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static SharedPreferencesPlusPlatform _instance =
      MethodChannelSharedPreferencesPlusPlatformInterface();

  /// The default instance of [SharedPreferencesPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelSharedPreferencesPlusPlatformInterface].
  static SharedPreferencesPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SharedPreferencesPlusPlatform] when
  /// they register themselves.
  static set instance(SharedPreferencesPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Methods
  /// Persists a string [value] for [key].
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Reads a string value for [key].
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Persists an integer [value] for [key].
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Reads an integer value for [key].
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Persists a double [value] for [key].
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Reads a double value for [key].
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Persists a boolean [value] for [key].
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Reads a boolean value for [key].
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Persists a string list [value] for [key].
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Reads a string list for [key].
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Removes the preference for [key].
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Clears all preferences for the configured [options].
  Future<void> clear({SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  /// Returns whether a value exists for [key].
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Returns all stored keys for the configured [options].
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
  /// Returns all stored key-value pairs for the configured [options].
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  });
}
