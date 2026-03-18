// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_linux/shared_preferences_plus_linux.dart';
// import 'package:shared_preferences_plus_linux/shared_preferences_plus_linux_platform_interface.dart';
// import 'package:shared_preferences_plus_linux/shared_preferences_plus_linux_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusLinuxPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusLinuxPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusLinuxPlatform initialPlatform = SharedPreferencesPlusLinuxPlatform.instance;

//   test('$MethodChannelSharedPreferencesPlusLinux is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusLinux>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlusLinux sharedPreferencesPlusLinuxPlugin = SharedPreferencesPlusLinux();
//     MockSharedPreferencesPlusLinuxPlatform fakePlatform = MockSharedPreferencesPlusLinuxPlatform();
//     SharedPreferencesPlusLinuxPlatform.instance = fakePlatform;

//     expect(await sharedPreferencesPlusLinuxPlugin.getPlatformVersion(), '42');
//   });
// }
