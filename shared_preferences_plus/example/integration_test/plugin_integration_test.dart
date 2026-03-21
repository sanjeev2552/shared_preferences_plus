import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shared preferences integration flow', (WidgetTester tester) async {
    final prefs = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'integration_test'),
    );

    await prefs.clear();
    await prefs.setString('string_key', 'value');
    expect(prefs.getString('string_key'), 'value');

    await prefs.remove('string_key');
    expect(prefs.getString('string_key'), isNull);

    await prefs.setInt('int_key', 7);
    expect(prefs.getInt('int_key'), 7);

    await prefs.setBool('bool_key', true);
    expect(prefs.getBool('bool_key'), true);

    await prefs.setStringList('list_key', <String>['a', 'b']);
    expect(prefs.getStringList('list_key'), <String>['a', 'b']);

    await prefs.reload();
    final all = prefs.getAll();
    expect(all.containsKey('int_key'), isTrue);
    expect(all.containsKey('bool_key'), isTrue);
    expect(all.containsKey('list_key'), isTrue);
  });
}
