import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_platform_interface/file_shared_preferences.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// Windows implementation with atomic updates and locks across isolates/processes.
class SharedPreferencesPlusWindows extends FileSharedPreferencesPlatform {
  /// Creates an implementation with optional injectable storage for tests.
  SharedPreferencesPlusWindows({FilePreferencesStore? store})
    : super(
        store ??
            FilePreferencesStore(
              directoryProvider:
                  PathProviderWindows().getApplicationSupportPath,
            ),
      );

  /// Registers this implementation.
  static void registerWith() {
    SharedPreferencesPlusPlatform.instance = SharedPreferencesPlusWindows();
  }
}
