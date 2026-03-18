// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_web/shared_preferences_plus_web.dart';
// import 'package:shared_preferences_plus_web/src/shared_preferences_plus_web_impl.dart';
// import 'package:shared_preferences_plus_web/src/shared_preferences_plus_web_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSharedPreferencesPlusWebPlatform
//     with MockPlatformInterfaceMixin
//     implements SharedPreferencesPlusWebPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SharedPreferencesPlusWebPlatform initialPlatform = SharedPreferencesPlusWebPlatform.instance;

//   test('$MethodChannelSharedPreferencesPlusWeb is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSharedPreferencesPlusWeb>());
//   });

//   test('getPlatformVersion', () async {
//     SharedPreferencesPlusWeb sharedPreferencesPlusWebPlugin = SharedPreferencesPlusWeb();
//     MockSharedPreferencesPlusWebPlatform fakePlatform = MockSharedPreferencesPlusWebPlatform();
//     SharedPreferencesPlusWebPlatform.instance = fakePlatform;

//     expect(await sharedPreferencesPlusWebPlugin.getPlatformVersion(), '42');
//   });
// }
