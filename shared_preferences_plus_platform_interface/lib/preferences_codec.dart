import 'dart:convert';

import 'preferences_values.dart';

/// Versioned JSON encoding that preserves doubles, including whole-valued ones,
/// negative zero and non-finite values. Legacy plain JSON maps remain readable.
class PreferencesCodec {
  static const _format = 'shared_preferences_plus/1';

  /// Encodes values in an explicitly typed envelope.
  static String encode(
    Map<String, Object?> values, {
    Map<String, String> types = const {},
  }) => jsonEncode({
    'format': _format,
    'values': copyPreferences(values).map(
      (key, value) => MapEntry(
        key,
        types[key] == 'double' && value is num
            ? ['double', value.toDouble().toString()]
            : switch (value) {
                String() => ['string', value],
                bool() => ['bool', value],
                int() => ['int', value.toString()],
                double() => ['double', value.toString()],
                List<String>() => ['list', value],
                _ => throw StateError('Unsupported preference type.'),
              },
      ),
    ),
  });

  /// Decodes the current format or a legacy untyped JSON map.
  static Map<String, Object> decode(String contents) =>
      decodeData(contents).values;

  /// Retains explicit types on JavaScript, where 1 and 1.0 share a number type.
  static DecodedPreferences decodeData(String contents) {
    final decoded = jsonDecode(contents);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Preferences must contain a JSON object.');
    }
    if (decoded['format'] is! String || decoded['values'] is! Map) {
      final values = copyPreferences(decoded);
      return DecodedPreferences(
        values,
        values.map(
          (key, value) => MapEntry(key, switch (value) {
            String() => 'string',
            bool() => 'bool',
            int() => 'int',
            double() => 'double',
            List<String>() => 'list',
            _ => throw const FormatException('Unsupported preference type.'),
          }),
        ),
      );
    }
    if (decoded['format'] != _format) {
      throw const FormatException('Unsupported preferences format version.');
    }
    final result = <String, Object?>{};
    final types = <String, String>{};
    for (final entry in (decoded['values'] as Map<String, dynamic>).entries) {
      final item = entry.value;
      if (item is! List || item.length != 2) {
        throw const FormatException('Malformed preference value.');
      }
      final Object? value = item[1];
      if (item[0] is! String) {
        throw const FormatException('Malformed preference type.');
      }
      types[entry.key] = item[0] as String;
      result[entry.key] = switch (item[0]) {
        'string' when value is String => value,
        'bool' when value is bool => value,
        'int' when value is String => int.parse(value),
        'double' when value is String => double.parse(value),
        'list'
            when value is List &&
                value.every((Object? item) => item is String) =>
          List<String>.from(value),
        _ => throw const FormatException('Malformed preference type.'),
      };
    }
    return DecodedPreferences(copyPreferences(result), types);
  }
}

/// Decoded values and their declared storage types.
class DecodedPreferences extends PreferencesSnapshot {
  /// Creates a decoded container.
  DecodedPreferences(super.values, super.types);
}
