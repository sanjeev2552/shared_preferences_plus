import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_platform_interface/in_memory_shared_preferences.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const stringKey = 'stringKey';
  const intKey = 'intKey';
  const doubleKey = 'doubleKey';
  const boolKey = 'boolKey';
  const stringListKey = 'stringListKey';

  const defaultStringValue = 'stringValue';
  const defaultIntValue = 42;
  const defaultDoubleValue = 3.14;
  const defaultBoolValue = true;
  const defaultStringListValue = <String>['a', 'b', 'c'];

  const customStringValue = 'customStringValue';
  const customIntValue = 100;
  const customDoubleValue = 2.718;
  const customBoolValue = false;
  const customStringListValue = <String>['x', 'y', 'z'];

  final SharedPreferencesPlusPlatform initialPlatform = SharedPreferencesPlusPlatform.instance;
  late FakeSharedPreferencesPlusPlatform fakePlatform;
  late SharedPreferencesPlus prefs;

  setUp(() async {
    fakePlatform = FakeSharedPreferencesPlusPlatform(
      initialData: {
        stringKey: defaultStringValue,
        intKey: defaultIntValue,
        doubleKey: defaultDoubleValue,
        boolKey: defaultBoolValue,
        stringListKey: defaultStringListValue,
      },
    );
    SharedPreferencesPlusPlatform.instance = fakePlatform;
    prefs = await SharedPreferencesPlus.getInstance();
  });

  tearDown(() {
    SharedPreferencesPlusPlatform.instance = initialPlatform;
    SharedPreferencesPlus.clearCache();
  });

  test("reading value from shared preferences", () {
    expect(prefs.getString(stringKey), defaultStringValue);
    expect(prefs.getInt(intKey), defaultIntValue);
    expect(prefs.getDouble(doubleKey), defaultDoubleValue);
    expect(prefs.getBool(boolKey), defaultBoolValue);
    expect(prefs.getStringList(stringListKey), defaultStringListValue);

    expect(
      fakePlatform.methodCalls,
      containsAllInOrder(<Matcher>[
        isMethodCall('getAll', arguments: {'options': 'SharedPreferencesPlus'}),
      ]),
    );
  });

  test("writing value to shared preferences", () async {
    await prefs.setString(stringKey, customStringValue);
    await prefs.setInt(intKey, customIntValue);
    await prefs.setDouble(doubleKey, customDoubleValue);
    await prefs.setBool(boolKey, customBoolValue);
    await prefs.setStringList(stringListKey, customStringListValue);

    expect(
      fakePlatform.methodCalls,
      containsAllInOrder(<Matcher>[
        isMethodCall(
          'setString',
          arguments: {
            'key': stringKey,
            'value': customStringValue,
            'options': 'SharedPreferencesPlus',
          },
        ),
        isMethodCall(
          'setInt',
          arguments: {'key': intKey, 'value': customIntValue, 'options': 'SharedPreferencesPlus'},
        ),
        isMethodCall(
          'setDouble',
          arguments: {
            'key': doubleKey,
            'value': customDoubleValue,
            'options': 'SharedPreferencesPlus',
          },
        ),
        isMethodCall(
          'setBool',
          arguments: {'key': boolKey, 'value': customBoolValue, 'options': 'SharedPreferencesPlus'},
        ),
        isMethodCall(
          'setStringList',
          arguments: {
            'key': stringListKey,
            // The value is encoded as a single string with a separator, so we check for that encoding here.
            // because the method call arguments are just a Map, we can't check the original List directly.
            'value': customStringListValue.join("/0001u"),
            'options': 'SharedPreferencesPlus',
          },
        ),
      ]),
    );

    // Verify that the values were actually stored.
    expect(prefs.getString(stringKey), customStringValue);
    expect(prefs.getInt(intKey), customIntValue);
    expect(prefs.getDouble(doubleKey), customDoubleValue);
    expect(prefs.getBool(boolKey), customBoolValue);
    expect(prefs.getStringList(stringListKey), customStringListValue);
  });

  test('reload refreshes cache from platform', () async {
    expect(prefs.getString('reload_key'), isNull);
    await SharedPreferencesPlusPlatform.instance.setString(
      'reload_key',
      'reload_value',
      options: prefs.options,
    );
    expect(prefs.getString('reload_key'), isNull);
    await prefs.reload();
    expect(prefs.getString('reload_key'), 'reload_value');
  });

  test('clearCache invalidates cache for options', () {
    expect(prefs.getString(stringKey), defaultStringValue);
    SharedPreferencesPlus.clearCache();
    expect(() => prefs.getString(stringKey), throwsStateError);
  });

  test('containsKey reports presence and absence', () async {
    await prefs.setString('present', 'x');
    expect(prefs.containsKey('present'), isTrue);
    expect(prefs.containsKey('absent'), isFalse);
    expect(
      fakePlatform.methodCalls.any(
        (call) =>
            call.method == "setString" &&
            call.arguments['key'] == 'present' &&
            call.arguments['options'] == prefs.options.name,
      ),
      isTrue,
    );
  });

  test('getKeys returns all keys', () async {
    await prefs.setString('a', 'x');
    await prefs.setInt('b', 1);
    expect(prefs.getKeys(), containsAll(<String>['a', 'b']));
    expect(
      fakePlatform.methodCalls.any(
        (call) => call.method == "setInt" && call.arguments['options'] == prefs.options.name,
      ),
      isTrue,
    );
  });

  test('getAll returns all values with string lists decoded', () async {
    await prefs.setString('a', 'x');
    await prefs.setInt('b', 1);
    await prefs.setStringList('c', <String>['m', 'n']);
    final all = prefs.getAll();
    expect(all['a'], 'x');
    expect(all['b'], 1);
    expect(all['c'], <String>['m', 'n']);
    expect(
      fakePlatform.methodCalls.any(
        (call) => call.method == "setStringList" && call.arguments['options'] == prefs.options.name,
      ),
      isTrue,
    );
  });

  test('remove deletes a key and is idempotent', () async {
    await prefs.setString('a', 'x');
    await prefs.remove('a');
    expect(prefs.containsKey('a'), isFalse);
    await prefs.remove('a');
    expect(prefs.containsKey('a'), isFalse);
    expect(
      fakePlatform.methodCalls.any(
        (call) =>
            call.method == "remove" &&
            call.arguments['key'] == 'a' &&
            call.arguments['options'] == prefs.options.name,
      ),
      isTrue,
    );
  });

  test('clear removes all keys', () async {
    await prefs.setString('a', 'x');
    await prefs.setInt('b', 1);
    await prefs.clear();
    expect(prefs.getKeys(), isEmpty);
    expect(
      fakePlatform.methodCalls.any(
        (call) => call.method == "clear" && call.arguments['options'] == prefs.options.name,
      ),
      isTrue,
    );
  });

  test('options are forwarded for every method', () async {
    final SharedPreferencesPlusOptions custom = SharedPreferencesPlusOptions(name: 'CustomPrefs');
    final SharedPreferencesPlus customPrefs = await SharedPreferencesPlus.getInstance(options: custom);
    const String key = 'k';

    await customPrefs.setString(key, 'v');
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    expect(customPrefs.getString(key), 'v');

    await customPrefs.setInt(key, 1);
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    expect(customPrefs.getInt(key), 1);

    await customPrefs.setDouble(key, 1.5);
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    expect(customPrefs.getDouble(key), 1.5);

    await customPrefs.setBool(key, true);
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    expect(customPrefs.getBool(key), true);

    await customPrefs.setStringList(key, <String>['a']);
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    expect(customPrefs.getStringList(key), <String>['a']);

    expect(customPrefs.containsKey(key), isTrue);
    expect(customPrefs.getKeys(), contains(key));
    expect(customPrefs.getAll()[key], isNotNull);
    await customPrefs.remove(key);
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
    await customPrefs.clear();
    expect(fakePlatform.lastOptions?.name, 'CustomPrefs');
  });

  test('mocking with initialData', () async {
    final SharedPreferencesPlusOptions custom = SharedPreferencesPlusOptions(name: 'CustomPrefs');
    final SharedPreferencesPlus customPrefs = await SharedPreferencesPlus.getInstance(options: custom);

    final SharedPreferencesPlusOptions newCustom = SharedPreferencesPlusOptions(
      name: 'CustomPrefs',
    );
    final SharedPreferencesPlus newCustomPrefs = await SharedPreferencesPlus.getInstance(options: newCustom);

    // Create mock data with default options
    SharedPreferencesPlus.setMockInitialValues({'key': 'value'});

    // Creating mock data with custom options should not affect the default options
    SharedPreferencesPlus.setMockInitialValues({'key': 'otherValue'}, options: custom);

    expect(prefs.getString("key"), equals("value"));
    expect(customPrefs.getString("key"), equals("otherValue"));
    expect(newCustomPrefs.getString("key"), equals("otherValue"));
  });
}

class FakeSharedPreferencesPlusPlatform extends SharedPreferencesPlusPlatform {
  FakeSharedPreferencesPlusPlatform({Map<String, Object?>? initialData})
    : _store = InMemorySharedPreferencesPlusPlatform.withData(initialData ?? {});

  final InMemorySharedPreferencesPlusPlatform _store;
  final List<MethodCall> methodCalls = <MethodCall>[];

  SharedPreferencesPlusOptions? lastOptions;

  void _record(SharedPreferencesPlusOptions options) {
    lastOptions = options;
  }

  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('setString', {'key': key, 'value': value, 'options': options.name}));
    await _store.setString(key, value, options: options);
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getString', {'key': key, 'options': options.name}));
    final value = await _store.getString(key, options: options);
    return value is String ? value : null;
  }

  @override
  Future<void> setInt(
    String key,
    int value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('setInt', {'key': key, 'value': value, 'options': options.name}));
    await _store.setInt(key, value, options: options);
  }

  @override
  Future<int?> getInt(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getInt', {'key': key, 'options': options.name}));
    final value = await _store.getInt(key, options: options);
    return value is int ? value : null;
  }

  @override
  Future<void> setDouble(
    String key,
    double value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('setDouble', {'key': key, 'value': value, 'options': options.name}));
    await _store.setDouble(key, value, options: options);
  }

  @override
  Future<double?> getDouble(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getDouble', {'key': key, 'options': options.name}));
    final value = await _store.getDouble(key, options: options);
    return value is double ? value : null;
  }

  @override
  Future<void> setBool(
    String key,
    bool value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('setBool', {'key': key, 'value': value, 'options': options.name}));
    await _store.setBool(key, value, options: options);
  }

  @override
  Future<bool?> getBool(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getBool', {'key': key, 'options': options.name}));
    final value = await _store.getBool(key, options: options);
    return value is bool ? value : null;
  }

  @override
  Future<void> setStringList(
    String key,
    List<String> value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(
      MethodCall('setStringList', {
        'key': key,
        'value': value.join("/0001u"),
        'options': options.name,
      }),
    );
    await _store.setStringList(key, value, options: options);
  }

  @override
  Future<List<String>?> getStringList(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getStringList', {'key': key, 'options': options.name}));
    final value = await _store.getStringList(key, options: options);
    return value;
  }

  @override
  Future<void> remove(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('remove', {'key': key, 'options': options.name}));
    await _store.remove(key, options: options);
  }

  @override
  Future<void> clear({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('clear', {'options': options.name}));
    await _store.clear(options: options);
  }

  @override
  Future<bool> containsKey(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('containsKey', {'key': key, 'options': options.name}));
    return await _store.containsKey(key, options: options);
  }

  @override
  Future<Set<String>> getKeys({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getKeys', {'options': options.name}));
    return await _store.getKeys(options: options);
  }

  @override
  Future<Map<String, Object>> getAll({
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) async {
    _record(options);
    methodCalls.add(MethodCall('getAll', {'options': options.name}));
    return await _store.getAll(options: options);
  }
}
