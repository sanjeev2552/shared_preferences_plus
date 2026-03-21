import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartPackageName: 'shared_preferences_plus_android',
    swiftOut: 'darwin/Classes/Messages.swift',
  ),
)
class SharedPreferencesPlusPigeonOptions {
  const SharedPreferencesPlusPigeonOptions(this.name);

  final String name;
}

@HostApi()
abstract class SharedPreferencesPlusApi {
  void setString(String key, String value, SharedPreferencesPlusPigeonOptions options);
  String? getString(String key, SharedPreferencesPlusPigeonOptions options);
  void setInt(String key, int value, SharedPreferencesPlusPigeonOptions options);
  int? getInt(String key, SharedPreferencesPlusPigeonOptions options);
  void setDouble(String key, double value, SharedPreferencesPlusPigeonOptions options);
  double? getDouble(String key, SharedPreferencesPlusPigeonOptions options);
  void setBool(String key, bool value, SharedPreferencesPlusPigeonOptions options);
  bool? getBool(String key, SharedPreferencesPlusPigeonOptions options);
  void setStringList(String key, List<String> value, SharedPreferencesPlusPigeonOptions options);
  List<String>? getStringList(String key, SharedPreferencesPlusPigeonOptions options);
  void remove(String key, SharedPreferencesPlusPigeonOptions options);
  void clear(SharedPreferencesPlusPigeonOptions options);
  bool containsKey(String key, SharedPreferencesPlusPigeonOptions options);
  List<String> getKeys(SharedPreferencesPlusPigeonOptions options);
  Map<String, Object?> getAll(SharedPreferencesPlusPigeonOptions options);
}
