import 'package:flutter/widgets.dart';
import 'package:shared_preferences_plus_android/src/messages.g.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class SharedPreferencesPlusAndroid extends SharedPreferencesPlusPlatform {
  final SharedPreferencesPlusApi _api;

  SharedPreferencesPlusAndroid({SharedPreferencesPlusApi? api})
    : _api =
          api ?? SharedPreferencesPlusApi(messageChannelSuffix: 'shared_preferences_plus_android');

  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusAndroid();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Getting string: key=$key, options=${options.name}');
    return _api.getString(key, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    debugPrint('Setting string: key=$key, value=$value, options=${options.name}');
    return _api.setString(key, value, SharedPreferencesPlusPigeonOptions(name: options.name ?? ''));
  }
}
