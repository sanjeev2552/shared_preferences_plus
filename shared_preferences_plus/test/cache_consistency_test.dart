import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class ControlledPlatform extends InMemorySharedPreferencesPlusPlatform {
  Completer<void>? readGate;
  Completer<void>? readStarted;
  bool failWrite = false;
  bool failRead = false;
  int reads = 0;
  @override
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    reads++;
    if (failRead) throw StateError('Injected read failure');
    final values = await super.getAll(options: options);
    readStarted?.complete();
    await readGate?.future;
    return values;
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    if (failWrite) throw StateError('Injected write failure');
    await super.setString(key, value, options: options);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ControlledPlatform platform;
  final original = SharedPreferencesPlusPlatform.instance;
  setUp(() {
    SharedPreferencesPlus.resetMockInitialValues();
    platform = ControlledPlatform();
    SharedPreferencesPlusPlatform.instance = platform;
  });
  tearDown(() {
    SharedPreferencesPlus.resetMockInitialValues();
    SharedPreferencesPlusPlatform.instance = original;
  });

  test(
    'deduplicates overlapping initialization and retries after failure',
    () async {
      platform.readGate = Completer<void>();
      final first = SharedPreferencesPlus.getInstance();
      final second = SharedPreferencesPlus.getInstance();
      expect(identical(first, second), isTrue);
      platform.readGate!.complete();
      await Future.wait([first, second]);
      expect(platform.reads, 1);
    },
  );
  test('reload and writes execute in call order', () async {
    await platform.setString('key', 'old');
    final prefs = await SharedPreferencesPlus.getInstance();
    platform.readGate = Completer<void>();
    platform.readStarted = Completer<void>();
    final reload = prefs.reload();
    await platform.readStarted!.future;
    var writeCompleted = false;
    final write = prefs.setString('key', 'new').then((_) {
      writeCompleted = true;
    });
    await Future<void>.delayed(Duration.zero);
    expect(writeCompleted, isFalse);
    platform.readGate!.complete();
    await Future.wait([reload, write]);
    expect(prefs.getString('key'), 'new');
    expect(await platform.getString('key'), 'new');
  });
  test('failed writes preserve cache and do not poison the queue', () async {
    final prefs = await SharedPreferencesPlus.getInstance();
    await prefs.setString('key', 'old');
    platform.failWrite = true;
    await expectLater(prefs.setString('key', 'bad'), throwsStateError);
    expect(prefs.getString('key'), 'old');
    platform.failWrite = false;
    await prefs.setString('key', 'new');
    expect(prefs.getString('key'), 'new');
  });

  test('failed initialization can retry without poisoning the queue', () async {
    platform.failRead = true;
    await expectLater(SharedPreferencesPlus.getInstance(), throwsStateError);
    platform.failRead = false;
    final prefs = await SharedPreferencesPlus.getInstance();
    expect(prefs.getAll(), isEmpty);
  });
  test('captures input lists immediately and detaches every output', () async {
    final prefs = await SharedPreferencesPlus.getInstance();
    final input = ['a'];
    final write = prefs.setStringList('list', input);
    input.add('caller');
    await write;
    (prefs.getAll()['list'] as List<String>).add('snapshot');
    prefs.getStringList('list')!.add('getter');
    expect(prefs.getStringList('list'), ['a']);
    expect(await platform.getStringList('list'), ['a']);
  });
  test('cache invalidation rejects an in-flight reload result', () async {
    final prefs = await SharedPreferencesPlus.getInstance();
    platform.readGate = Completer<void>();
    platform.readStarted = Completer<void>();
    final reload = prefs.reload();
    await platform.readStarted!.future;
    SharedPreferencesPlus.clearCache();
    platform.readGate!.complete();
    await reload;
    expect(prefs.getAll, throwsStateError);
    platform.readGate = null;
    platform.readStarted = null;
    await prefs.reload();
    expect(prefs.getAll(), isEmpty);
  });
  test('instances share namespace queues and clear/remove ordering', () async {
    final first = await SharedPreferencesPlus.getInstance();
    final second = await SharedPreferencesPlus.getInstance();
    await Future.wait([
      first.setString('a', '1'),
      second.clear(),
      first.setString('b', '2'),
      second.remove('b'),
    ]);
    expect(first.getAll(), isEmpty);
    expect(await platform.getAll(), isEmpty);
  });
  test('mock reset clears all namespaces and seed aliases', () async {
    const options = SharedPreferencesPlusOptions(name: 'custom');
    final input = ['seed'];
    SharedPreferencesPlus.setMockInitialValues({
      'list': input,
    }, options: options);
    final prefs = await SharedPreferencesPlus.getInstance(options: options);
    input.add('caller');
    expect(prefs.getStringList('list'), ['seed']);
    SharedPreferencesPlus.resetMockInitialValues();
    expect(prefs.getAll, throwsStateError);
    final fresh = await SharedPreferencesPlus.getInstance(options: options);
    expect(fresh.getAll(), isEmpty);
  });
}
