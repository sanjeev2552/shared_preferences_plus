import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_platform_interface/file_shared_preferences.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// Linux implementation with atomic updates and locks across isolates/processes.
class SharedPreferencesPlusLinux extends FileSharedPreferencesPlatform {
  /// Creates an implementation with optional injectable storage for tests.
  SharedPreferencesPlusLinux({FilePreferencesStore? store})
    : super(
        store ??
            FilePreferencesStore(
              directoryProvider: PathProviderLinux().getApplicationSupportPath,
            ),
      );

  /// Registers this implementation.
  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusLinux();
  }
}
