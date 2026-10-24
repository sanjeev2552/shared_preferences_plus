import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// The same observable storage contract for every platform implementation.
void platformContract(
  Future<SharedPreferencesPlusPlatform> Function() create, {
  Future<void> Function()? cleanup,
}) {
  late SharedPreferencesPlusPlatform platform;
  const other = SharedPreferencesPlusOptions(name: 'contract_other');
  setUp(() async {
    platform = await create();
    await platform.clear();
    await platform.clear(options: other);
  });
  if (cleanup != null) tearDown(cleanup);

  test('round trips every type through getAll and typed getters', () async {
    await platform.setString('string', 'Unicode 🐦 /0001u');
    await platform.setInt('int', 9007199254740991);
    await platform.setDouble('double', 1.0000000000000002);
    await platform.setBool('bool', true);
    await platform.setStringList('list', ['a/0001ub', '', '重复', '重复']);
    expect(await platform.getString('string'), 'Unicode 🐦 /0001u');
    expect(await platform.getInt('int'), 9007199254740991);
    expect(await platform.getDouble('double'), 1.0000000000000002);
    expect(await platform.getBool('bool'), isTrue);
    expect(await platform.getStringList('list'), ['a/0001ub', '', '重复', '重复']);
    expect(await platform.getAll(), {
      'string': 'Unicode 🐦 /0001u',
      'int': 9007199254740991,
      'double': 1.0000000000000002,
      'bool': true,
      'list': ['a/0001ub', '', '重复', '重复'],
    });
  });
  test('preserves whole doubles, negative zero, and list edge cases', () async {
    await platform.setDouble('whole', 1.0);
    await platform.setDouble('zero', -0.0);
    await platform.setStringList('empty', []);
    await platform.setStringList('single', ['only']);
    await platform.setStringList('emptyString', ['']);
    expect((await platform.getAll())['whole'], isA<double>());
    expect((await platform.getDouble('zero'))!.isNegative, isTrue);
    expect(await platform.getStringList('empty'), isEmpty);
    expect(await platform.getStringList('single'), ['only']);
    expect(await platform.getStringList('emptyString'), ['']);
  });
  test('keeps namespaces isolated and removal idempotent', () async {
    await platform.setString('key', 'default');
    await platform.setString('key', 'other', options: other);
    await platform.clear();
    expect(await platform.containsKey('key'), isFalse);
    expect(await platform.getString('key', options: other), 'other');
    expect(await platform.getKeys(options: other), {'key'});
    await platform.remove('key', options: other);
    await platform.remove('key', options: other);
    expect(await platform.getAll(options: other), isEmpty);
  });
  test('returns null on missing keys and type mismatch', () async {
    expect(await platform.getString('missing'), isNull);
    await platform.setString('key', 'one');
    expect(await platform.getInt('key'), isNull);
    expect(await platform.getDouble('key'), isNull);
    expect(await platform.getBool('key'), isNull);
    await platform.setInt('key', 1);
    expect(await platform.getDouble('key'), isNull);
    expect(await platform.getBool('key'), isNull);
    expect(await platform.getString('key'), isNull);
  });
  test(
    'rejects nonportable container names before accessing storage',
    () async {
      for (final name in [
        '',
        '../escape',
        'a/b',
        r'a\b',
        '\u0000',
        'x' * 129,
      ]) {
        await expectLater(
          () => platform.setString(
            'key',
            'value',
            options: SharedPreferencesPlusOptions(name: name),
          ),
          throwsArgumentError,
        );
      }
      expect(await platform.getAll(), isEmpty);
    },
  );
  test('detaches caller lists and returned snapshots', () async {
    final input = ['original'];
    final write = platform.setStringList('list', input);
    input.add('caller');
    await write;
    final all = await platform.getAll();
    (all['list'] as List<String>).add('snapshot');
    expect(await platform.getStringList('list'), ['original']);
  });
}
