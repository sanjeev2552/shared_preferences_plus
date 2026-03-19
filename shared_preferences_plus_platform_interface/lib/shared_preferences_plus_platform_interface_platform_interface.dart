import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

import 'shared_preferences_plus_platform_interface_method_channel.dart';

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
  Future<void> setString(String key, String value, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<String?> getString(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> setInt(String key, int value, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<int?> getInt(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> setDouble(String key, double value, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<double?> getDouble(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> setBool(String key, bool value, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<bool?> getBool(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> setStringList(String key, List<String> value, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<List<String>?> getStringList(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> remove(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<void> clear({SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<bool> containsKey(String key, {SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  Future<Set<String>> getKeys({SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions()});
  
}
