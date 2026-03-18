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
}
