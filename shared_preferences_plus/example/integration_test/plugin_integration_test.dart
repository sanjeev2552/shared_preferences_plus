import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_test_support/persisted_values.dart';
import 'package:shared_preferences_plus_test_support/platform_contract.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  platformContract(() async => SharedPreferencesPlusPlatform.instance);
  testWidgets('public API preserves every value and type after reload', (
    tester,
  ) async {
    final prefs = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'integration_test'),
    );
    await prefs.clear();
    addTearDown(prefs.clear);
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
    await prefs.reload();
    expect(prefs.getAll(), persistedValues);
    expect(prefs.getDouble('whole'), 1.0);
    expect(prefs.getDouble('precise'), 1.0000000000000002);
    expect(prefs.getDouble('zero')!.isNegative, isTrue);
    expect(prefs.getInt('whole'), isNull);
    expect(prefs.getDouble('int'), isNull);
    expect(prefs.getStringList('empty'), isEmpty);
    expect(prefs.getStringList('single'), ['only']);
    await Future.wait(
      List.generate(15, (i) => prefs.setInt('concurrent$i', i)),
    );
    await prefs.reload();
    for (var i = 0; i < 15; i++) {
      expect(prefs.getInt('concurrent$i'), i);
    }
    (prefs.getAll()['list'] as List<String>).add('unpersisted');
    expect(prefs.getStringList('list'), persistedValues['list']);
  });
}
