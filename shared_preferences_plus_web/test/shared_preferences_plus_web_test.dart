@TestOn('browser')
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_web/shared_preferences_plus_web.dart';
import 'package:web/web.dart' as web;
import 'package:shared_preferences_plus_test_support/platform_contract.dart';

class TestStorage implements PreferencesWebStorage {
  final values = <String, String>{};
  Object? failure;
  @override
  String? read(String name) {
    if (failure != null) throw failure!;
    return values[name];
  }

  @override
  void write(String name, String value) {
    if (failure != null) throw failure!;
    values[name] = value;
  }

  @override
  void remove(String name) {
    if (failure != null) throw failure!;
    values.remove(name);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Dart storage failures retain their original error', () async {
    final failure = StateError('Storage adapter failed');
    final storage = TestStorage()..failure = failure;
    final platform = SharedPreferencesPlusWeb(storage: storage);
    await expectLater(platform.getAll(), throwsA(same(failure)));
  });
  platformContract(
    () async => SharedPreferencesPlusWeb(storage: TestStorage()),
  );

  test(
    'fresh adapters preserve explicit numeric types after unrelated writes',
    () async {
      final storage = TestStorage();
      final first = SharedPreferencesPlusWeb(storage: storage);
      await first.setInt('int', 1);
      await first.setDouble('whole', 1.0);
      final recreated = SharedPreferencesPlusWeb(storage: storage);
      await recreated.setString('other', 'value');
      expect(await recreated.getInt('whole'), isNull);
      expect(await recreated.getDouble('int'), isNull);
      expect(await recreated.getDouble('whole'), 1.0);
      final snapshot = await recreated.getSnapshot();
      expect(snapshot.types['whole'], 'double');
      expect(snapshot.types['int'], 'int');
    },
  );
  test(
    'legacy JSON remains readable and migrates on a successful write',
    () async {
      final storage = TestStorage()
        ..values['SharedPreferencesPlus'] =
            '{"legacy":"value","list":["a"],"number":1.5}';
      final platform = SharedPreferencesPlusWeb(storage: storage);
      expect(await platform.getStringList('list'), ['a']);
      expect(await platform.getDouble('number'), 1.5);
      await platform.setBool('new', true);
      expect(await platform.getString('legacy'), 'value');
      expect(
        storage.values['SharedPreferencesPlus'],
        contains('shared_preferences_plus/1'),
      );
    },
  );
  test(
    'corruption is preserved until the container is explicitly cleared',
    () async {
      final storage = TestStorage()
        ..values['SharedPreferencesPlus'] = '{broken';
      final platform = SharedPreferencesPlusWeb(storage: storage);
      await expectLater(platform.getAll(), throwsFormatException);
      await expectLater(
        platform.setString('key', 'value'),
        throwsFormatException,
      );
      expect(storage.values['SharedPreferencesPlus'], '{broken');
      await platform.clear();
      expect(await platform.getAll(), isEmpty);
    },
  );
  test(
    'quota and security failures are asynchronous actionable errors',
    () async {
      final storage = TestStorage();
      final platform = SharedPreferencesPlusWeb(storage: storage);
      for (final name in ['QuotaExceededError', 'SecurityError']) {
        storage.failure = web.DOMException('Denied', name);
        final expected = name == 'QuotaExceededError'
            ? 'storage-full'
            : 'storage-unavailable';
        await expectLater(
          platform.setString('key', 'private'),
          throwsA(
            isA<PlatformException>().having((e) => e.code, 'code', expected),
          ),
        );
      }
    },
  );
  test('real localStorage persists values across adapter recreation', () async {
    const options = SharedPreferencesPlusOptions(
      name: 'shared_preferences_plus_browser_contract',
    );
    final first = SharedPreferencesPlusWeb();
    addTearDown(() => first.clear(options: options));
    await first.setStringList('list', ['', 'a/0001ub'], options: options);
    await first.setDouble('double', 1.0, options: options);
    final recreated = SharedPreferencesPlusWeb();
    expect(await recreated.getStringList('list', options: options), [
      '',
      'a/0001ub',
    ]);
    expect(await recreated.getDouble('double', options: options), 1.0);
    expect(await recreated.getInt('double', options: options), isNull);
  });
}
