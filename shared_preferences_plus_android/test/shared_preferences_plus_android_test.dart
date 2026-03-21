import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_android/shared_preferences_plus_android.dart';
import 'package:shared_preferences_plus_android/src/messages.g.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getAll decodes string lists', () async {
    final fakeApi = FakeSharedPreferencesPlusApi()
      ..allResult = <String, Object?>{
        'string': 'value',
        'listEncoded': 'a/0001ub/0001uc',
        'listRaw': <String>['x', 'y'],
      };

    final platform = SharedPreferencesPlusAndroid(api: fakeApi);

    final result = await platform.getAll();
    expect(result['string'], 'value');
    expect(result['listEncoded'], <String>['a', 'b', 'c']);
    expect(result['listRaw'], <String>['x', 'y']);
  });

  test('getKeys returns a Set and forwards options', () async {
    final fakeApi = FakeSharedPreferencesPlusApi()..keysResult = <String>['a', 'b'];
    final platform = SharedPreferencesPlusAndroid(api: fakeApi);
    const options = SharedPreferencesPlusOptions(name: 'CustomPrefs');

    final keys = await platform.getKeys(options: options);
    expect(keys, <String>{'a', 'b'});
    expect(fakeApi.lastOptions?.name, 'CustomPrefs');
  });

  test('containsKey forwards options', () async {
    final fakeApi = FakeSharedPreferencesPlusApi()..containsKeyResult = true;
    final platform = SharedPreferencesPlusAndroid(api: fakeApi);
    const options = SharedPreferencesPlusOptions(name: 'CustomPrefs');

    final exists = await platform.containsKey('key', options: options);
    expect(exists, isTrue);
    expect(fakeApi.lastOptions?.name, 'CustomPrefs');
  });
}

class FakeSharedPreferencesPlusApi extends SharedPreferencesPlusApi {
  FakeSharedPreferencesPlusApi() : super();

  SharedPreferencesPlusPigeonOptions? lastOptions;
  Map<String, Object?> allResult = <String, Object?>{};
  List<String> keysResult = <String>[];
  bool containsKeyResult = false;

  void _record(SharedPreferencesPlusPigeonOptions options) {
    lastOptions = options;
  }

  @override
  Future<Map<String, Object?>> getAll(SharedPreferencesPlusPigeonOptions options) async {
    _record(options);
    return allResult;
  }

  @override
  Future<List<String>> getKeys(SharedPreferencesPlusPigeonOptions options) async {
    _record(options);
    return keysResult;
  }

  @override
  Future<bool> containsKey(String key, SharedPreferencesPlusPigeonOptions options) async {
    _record(options);
    return containsKeyResult;
  }
}
