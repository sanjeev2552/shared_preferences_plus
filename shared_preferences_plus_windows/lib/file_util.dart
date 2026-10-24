import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';
import 'package:shared_preferences_plus_platform_interface/preferences_values.dart';

/// Compatibility utilities backed by transactional file storage.
class FileUtil {
  FileUtil._();
  static final _store = FilePreferencesStore(
    directoryProvider: PathProviderWindows().getApplicationSupportPath,
  );

  /// Reads a detached snapshot.
  static Future<Map<String, Object?>> readPreferences(
    SharedPreferencesPlusOptions options,
  ) => _store.read(options.storageName);

  /// Replaces a snapshot. Prefer platform setters for atomic read-modify-write.
  static Future<void> writePreferences(
    SharedPreferencesPlusOptions options,
    Map<String, Object?> preferences,
  ) {
    final snapshot = copyPreferences(preferences);
    return _store.update(options.storageName, (values) {
      values
        ..clear()
        ..addAll(snapshot);
    });
  }
}
