// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences_plus_windows/shared_preferences_plus_windows_method_channel.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   MethodChannelSharedPreferencesPlusWindows platform = MethodChannelSharedPreferencesPlusWindows();
//   const MethodChannel channel = MethodChannel('shared_preferences_plus_windows');

//   setUp(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
//         .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
//           return '42';
//         });
//   });

//   tearDown(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
//         .setMockMethodCallHandler(channel, null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
