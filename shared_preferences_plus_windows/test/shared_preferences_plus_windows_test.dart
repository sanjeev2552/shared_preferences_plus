// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_windows/shared_preferences_plus_windows.dart';
// import 'package:shared_preferences_plus_windows/shared_preferences_plus_windows_platform_interface.dart';
// import 'package:shared_preferences_plus_windows/shared_preferences_plus_windows_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusWindowsPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusWindowsPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusWindowsPlatform initialPlatform = SharedPreferencesPlusWindowsPlatform.instance;

//   test('$MethodChannelSharedPreferencesPlusWindows is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusWindows>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlusWindows sharedPreferencesPlusWindowsPlugin = SharedPreferencesPlusWindows();
//     MockSharedPreferencesPlusWindowsPlatform fakePlatform = MockSharedPreferencesPlusWindowsPlatform();
//     SharedPreferencesPlusWindowsPlatform.instance = fakePlatform;

//     expect(await sharedPreferencesPlusWindowsPlugin.getPlatformVersion(), '42');
//   });
// }
