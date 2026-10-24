import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_test_support/persisted_values.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('writes values for a separate process to verify', (tester) async {
    final prefs = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'restart_contract'),
    );
    await prefs.clear();
    for (final entry in persistedValues.entries) {
      final value = entry.value;
      if (const {'whole', 'precise', 'zero'}.contains(entry.key)) {
        await prefs.setDouble(entry.key, value as double);
        continue;
      }
      switch (value) {
        case String():
          await prefs.setString(entry.key, value);
        case bool():
          await prefs.setBool(entry.key, value);
        case int():
          await prefs.setInt(entry.key, value);
        case double():
          await prefs.setDouble(entry.key, value);
        case List<String>():
          await prefs.setStringList(entry.key, value);
      }
    }
    await prefs.setString(
      'token',
      const String.fromEnvironment(
        'PREFERENCES_RESTART_TOKEN',
        defaultValue: 'manual',
      ),
    );
    // Native preferences flush asynchronously; allow a normal flush before a
    // graceful app exit. This does not claim power-loss durability.
    await Future<void>.delayed(const Duration(seconds: 1));
  });
}
