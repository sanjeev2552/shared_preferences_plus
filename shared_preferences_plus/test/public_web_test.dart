@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_web/shared_preferences_plus_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('public cache retains Web numeric types across reloads', () async {
    final original = SharedPreferencesPlusPlatform.instance;
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWeb();
    const options = SharedPreferencesPlusOptions(
      name: 'public_browser_contract',
    );
    final prefs = await SharedPreferencesPlus.getInstance(options: options);
    addTearDown(() async {
      await prefs.clear();
      SharedPreferencesPlus.clearCache(options: options);
      SharedPreferencesPlusPlatform.instance = original;
    });
    await prefs.clear();
    await prefs.setInt('int', 1);
    await prefs.setDouble('double', 1.0);
    expect(prefs.getDouble('int'), isNull);
    expect(prefs.getInt('double'), isNull);
    await prefs.reload();
    expect(prefs.getDouble('double'), 1.0);
    expect(prefs.getInt('int'), 1);
    expect(prefs.getDouble('int'), isNull);
    expect(prefs.getInt('double'), isNull);
    await prefs.setString('unrelated', 'value');
    await prefs.reload();
    expect(prefs.getDouble('double'), 1.0);
    expect(prefs.getInt('double'), isNull);
  });
}
