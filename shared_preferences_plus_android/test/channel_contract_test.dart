import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_android/shared_preferences_plus_android.dart';
import 'package:shared_preferences_plus_android/src/messages.g.dart';
import 'package:shared_preferences_plus_test_support/platform_contract.dart';
import 'package:shared_preferences_plus_test_support/pigeon_host.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  platformContract(() async {
    installPigeonHost(
      codec: SharedPreferencesPlusApi.pigeonChannelCodec,
      channelPrefix:
          'dev.flutter.pigeon.shared_preferences_plus_android.SharedPreferencesPlusApi',
      containerName: (options) =>
          (options! as SharedPreferencesPlusPigeonOptions).name,
    );
    return SharedPreferencesPlusAndroid(api: SharedPreferencesPlusApi());
  });
}
