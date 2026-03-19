// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class SharedPreferencesPlus {
  static SharedPreferencesPlusPlatform get _platform => SharedPreferencesPlusPlatform.instance;

  final SharedPreferencesPlusOptions options;
  SharedPreferencesPlus({this.options = const SharedPreferencesPlusOptions()});

  Future<void> setString(String key, String value) {
    return _platform.setString(key, value, options: options);
  }

  Future<String?> getString(String key) {
    return _platform.getString(key, options: options);
  }

  Future<void> setInt(String key, int value) {
    return _platform.setInt(key, value, options: options);
  }

  Future<int?> getInt(String key) {
    return _platform.getInt(key, options: options);
  }

  Future<void> setDouble(String key, double value) {
    return _platform.setDouble(key, value, options: options);
  }

  Future<double?> getDouble(String key) {
    return _platform.getDouble(key, options: options);
  }

  Future<void> setBool(String key, bool value) {
    return _platform.setBool(key, value, options: options);
  }

  Future<bool?> getBool(String key) {
    return _platform.getBool(key, options: options);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _platform.setStringList(key, value, options: options);
  }

  Future<List<String>?> getStringList(String key) {
    return _platform.getStringList(key, options: options);
  }

  Future<void> remove(String key) {
    return _platform.remove(key, options: options);
  }

  Future<void> clear() {
    return _platform.clear(options: options);
  }

  Future<bool> containsKey(String key) {
    return _platform.containsKey(key, options: options);
  }

  Future<Set<String>> getKeys() {
    return _platform.getKeys(options: options);
  }
}
