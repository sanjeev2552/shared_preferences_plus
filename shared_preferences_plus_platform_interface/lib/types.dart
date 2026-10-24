import 'dart:convert';

/// Options controlling how shared preferences are stored and scoped.
class SharedPreferencesPlusOptions {
  /// Creates options with an optional storage [name].
  const SharedPreferencesPlusOptions({String? name})
    : name = name ?? 'SharedPreferencesPlus';

  /// The preferences container name.
  final String? name;

  /// A portable container name. Validation runs in release builds as well as
  /// debug builds, before any backend accesses storage.
  String get storageName {
    final value = name ?? 'SharedPreferencesPlus';
    if (value.isEmpty ||
        value == '.' ||
        value == '..' ||
        value.contains('/') ||
        value.contains('\\') ||
        value.contains('\u0000') ||
        utf8.encode(value).length > 128) {
      throw ArgumentError.value(
        value,
        'name',
        'Use 1–128 UTF-8 bytes without path separators or NUL',
      );
    }
    return value;
  }
}
