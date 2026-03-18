import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

import 'shared_preferences_plus_platform_interface_platform_interface.dart';

/// An implementation of [SharedPreferencesPlusPlatform] that uses method channels.
class MethodChannelSharedPreferencesPlusPlatformInterface extends SharedPreferencesPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shared_preferences_plus_platform_interface');

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<void>('setString', {'key': key, 'value': value});
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    return methodChannel.invokeMethod<String>('getString', {'key': key});
  }
}
