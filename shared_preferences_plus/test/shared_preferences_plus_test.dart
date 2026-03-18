// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus/shared_preferences_plus.dart';
// import 'package:shared_preferences_plus/shared_preferences_plus_platform_interface.dart';
// import 'package:shared_preferences_plus/shared_preferences_plus_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusPlatform initialPlatform = SharedPreferencesPlusPlatform.instance;

//   test('$MethodChannelSharedPreferencesPlus is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlus>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlus sharedPreferencesPlusPlugin = SharedPreferencesPlus();
//     MockSharedPreferencesPlusPlatform fakePlatform = MockSharedPreferencesPlusPlatform();
//     SharedPreferencesPlusPlatform.instance = fakePlatform;

//     expect(await sharedPreferencesPlusPlugin.getPlatformVersion(), '42');
//   });
// }
