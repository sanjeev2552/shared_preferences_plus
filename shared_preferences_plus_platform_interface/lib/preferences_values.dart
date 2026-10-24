/// Creates a detached, typed snapshot of supported preference values.
Map<String, Object> copyPreferences(Map<String, Object?> values) {
  final result = <String, Object>{};
  for (final entry in values.entries) {
    final value = entry.value;
    if (value is String || value is int || value is double || value is bool) {
      result[entry.key] = value!;
    } else if (value is List && value.every((Object? item) => item is String)) {
      result[entry.key] = List<String>.from(value);
    } else if (value != null) {
      throw FormatException(
        'Unsupported preference type for key "${entry.key}".',
      );
    }
  }
  return result;
}

/// Values and declared types from one storage read. Explicit types retain the
/// distinction between integer and double values on JavaScript runtimes.
class PreferencesSnapshot {
  /// Creates a snapshot with explicit type names.
  PreferencesSnapshot(this.values, this.types);

  /// Infers types on platforms that preserve them in their runtime values.
  factory PreferencesSnapshot.fromValues(Map<String, Object?> source) {
    final values = copyPreferences(source);
    return PreferencesSnapshot(
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

  /// Detached values.
  final Map<String, Object> values;

  /// Type name per key: string, int, double, bool or list.
  final Map<String, String> types;
}
