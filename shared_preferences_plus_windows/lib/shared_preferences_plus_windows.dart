import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';
import 'package:shared_preferences_plus_windows/file_util.dart';

class SharedPreferencesPlusWindows extends SharedPreferencesPlusPlatform {
  SharedPreferencesPlusWindows();

  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWindows();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await FileUtil.readPreferences(options);
    return jsonData[key] as String?;
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    final jsonData = await FileUtil.readPreferences(options);
    jsonData[key] = value;
    await FileUtil.writePreferences(options, jsonData);
  }
}
