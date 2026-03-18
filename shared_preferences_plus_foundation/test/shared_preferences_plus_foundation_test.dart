// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_foundation/shared_preferences_plus_foundation.dart';
// import 'package:shared_preferences_plus_foundation/src/shared_preferences_plus_foundation_platform_interface.dart';
// import 'package:shared_preferences_plus_foundation/shared_preferences_plus_foundation_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusFoundationPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusFoundation {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusFoundation initialPlatform = SharedPreferencesPlusFoundation.instance;

//   test('$MethodChannelSharedPreferencesPlusFoundation is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusFoundation>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlusFoundation sharedPreferencesPlusFoundationPlugin =
//         SharedPreferencesPlusFoundation();
//     MockSharedPreferencesPlusFoundationPlatform fakePlatform =
//         MockSharedPreferencesPlusFoundationPlatform();
//     SharedPreferencesPlusFoundation.instance = fakePlatform;

//     expect(await sharedPreferencesPlusFoundationPlugin.getPlatformVersion(), '42');
//   });
// }
