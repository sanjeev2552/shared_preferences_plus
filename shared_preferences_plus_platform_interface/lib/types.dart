/// Options controlling how shared preferences are stored and scoped.
class SharedPreferencesPlusOptions {
  /// Creates options with an optional storage [name].
  const SharedPreferencesPlusOptions({String? name}) : name = name ?? 'SharedPreferencesPlus';

  /// The preferences container name.
  final String? name;
}
