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

  // static SharedPreferencesPlus init({
  //   SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  // }) {
  //   _platform.init(options: options);
  //   return SharedPreferencesPlus();
  // }

  Future<void> setString(String key, String value) {
    return _platform.setString(key, value, options: options);
  }

  Future<String?> getString(String key) {
    return _platform.getString(key, options: options);
  }
}
