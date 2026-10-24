import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';
import 'package:shared_preferences_plus_test_support/platform_contract.dart';

void main() {
  platformContract(() async => InMemorySharedPreferencesPlusPlatform());
  test('mock instances and seed values are isolated', () async {
    final seed = <String, Object?>{
      'list': ['a'],
    };
    final first = InMemorySharedPreferencesPlusPlatform.withData(seed);
    final second = InMemorySharedPreferencesPlusPlatform();
    (seed['list'] as List<String>).add('b');
    expect(await first.getStringList('list'), ['a']);
    expect(await second.getAll(), isEmpty);
    first.reset();
    expect(await first.getAll(), isEmpty);
  });
}
