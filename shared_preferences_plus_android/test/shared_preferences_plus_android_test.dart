// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_android/shared_preferences_plus_android.dart';
// import 'package:shared_preferences_plus_android/src/shared_preferences_plus_android_platform_interface.dart';
// import 'package:shared_preferences_plus_android/shared_preferences_plus_android_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusAndroidPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusAndroid {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusAndroid initialPlatform = SharedPreferencesPlusAndroid.instance;

//   test('$MethodChannelSharedPreferencesPlusAndroid is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusAndroid>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlusAndroid sharedPreferencesPlusAndroidPlugin =
//         SharedPreferencesPlusAndroid();
//     MockSharedPreferencesPlusAndroidPlatform fakePlatform =
//         MockSharedPreferencesPlusAndroidPlatform();
//     SharedPreferencesPlusAndroid.instance = fakePlatform;

//     expect(await sharedPreferencesPlusAndroidPlugin.getPlatformVersion(), '42');
//   });
// }
