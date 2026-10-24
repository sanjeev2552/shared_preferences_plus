import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/preferences_codec.dart';

void main() {
  test('typed JSON preserves numeric identity and special doubles', () {
    final values = PreferencesCodec.decode(
      PreferencesCodec.encode({
        'int': 1,
        'double': 1.0,
        'zero': -0.0,
        'nan': double.nan,
        'infinity': double.infinity,
        'negativeInfinity': double.negativeInfinity,
        'list': ['a', '', 'a'],
      }),
    );
    expect(values['int'], isA<int>());
    expect(values['double'], isA<double>());
    expect((values['zero'] as double).isNegative, isTrue);
    expect((values['nan'] as double).isNaN, isTrue);
    expect(values['infinity'], double.infinity);
    expect(values['negativeInfinity'], double.negativeInfinity);
    expect(values['list'], ['a', '', 'a']);
  });
  test('reads legacy maps including keys resembling envelope metadata', () {
    expect(
      PreferencesCodec.decode('{"format":"mine","values":["a"],"number":1.5}'),
      {
        'format': 'mine',
        'values': ['a'],
        'number': 1.5,
      },
    );
  });
  test('rejects malformed data and future formats without erasing them', () {
    for (final text in [
      '[]',
      '{',
      '{"format":"shared_preferences_plus/9","values":{}}',
      '{"format":"shared_preferences_plus/1","values":{"key":["double",false]}}',
    ]) {
      expect(() => PreferencesCodec.decode(text), throwsFormatException);
    }
  });
}
