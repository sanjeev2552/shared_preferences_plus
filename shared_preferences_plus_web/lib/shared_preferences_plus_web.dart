// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:web/web.dart' as web;

/// A web implementation of the SharedPreferencesPlusWebPlatform of the SharedPreferencesPlusWeb plugin.
class SharedPreferencesPlusWeb extends SharedPreferencesPlusPlatform {
  /// Constructs a SharedPreferencesPlusWebWeb
  final storageMap = <String, dynamic>{};
  SharedPreferencesPlusWeb();

  static void registerWith(Registrar registrar) {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWeb();
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final currentValue = web.window.localStorage.getItem(options.name ?? '');
    if (currentValue == null) {
      return Future.value(null);
    }
    final Map<String, dynamic> decoded = jsonDecode(currentValue) as Map<String, dynamic>;
    return Future.value(decoded[key] as String?);
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    final currentValue = web.window.localStorage.getItem(options.name ?? '');
    final Map<String, dynamic> decoded = currentValue != null
        ? jsonDecode(currentValue) as Map<String, dynamic>
        : <String, dynamic>{};
    decoded[key] = value;
    web.window.localStorage.setItem(options.name ?? '', jsonEncode(decoded));
    return Future.value();
  }
}
