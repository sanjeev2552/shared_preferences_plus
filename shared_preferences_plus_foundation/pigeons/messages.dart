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
}
