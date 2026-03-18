import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_method_channel.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';

// class MockSharedPreferencesPlusPlatformInterfacePlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

void main() {
  final SharedPreferencesPlusPlatform initialPlatform = SharedPreferencesPlusPlatform.instance;

  test('$MethodChannelSharedPreferencesPlusPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    // SharedPreferencesPlusPlatformInterface sharedPreferencesPlusPlatformInterfacePlugin =
    //     SharedPreferencesPlusPlatformInterface();
    // MockSharedPreferencesPlusPlatformInterfacePlatform fakePlatform =
    //     MockSharedPreferencesPlusPlatformInterfacePlatform();
    // SharedPreferencesPlusPlatform.instance = fakePlatform;

    // expect(await sharedPreferencesPlusPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
