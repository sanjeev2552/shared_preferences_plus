import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_test_support/persisted_values.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('reads values from the previous application process', (
    tester,
  ) async {
    final prefs = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'restart_contract'),
    );
    addTearDown(prefs.clear);
    expect(
      prefs.getString('token'),
      const String.fromEnvironment(
        'PREFERENCES_RESTART_TOKEN',
        defaultValue: 'manual',
      ),
    );
    await prefs.remove('token');
    expect(prefs.getAll(), persistedValues);
    expect(prefs.getDouble('whole'), 1.0);
    expect(prefs.getDouble('precise'), 1.0000000000000002);
    expect(prefs.getDouble('zero')!.isNegative, isTrue);
    expect(prefs.getInt('whole'), isNull);
    expect(prefs.getDouble('int'), isNull);
    expect(prefs.getStringList('empty'), isEmpty);
    expect(prefs.getStringList('single'), ['only']);
  });
}
