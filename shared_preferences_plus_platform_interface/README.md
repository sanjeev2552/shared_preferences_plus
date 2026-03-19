# shared_preferences_plus_platform_interface

A common platform interface for the `shared_preferences_plus` plugin.

This interface allows platform-specific implementations of the `shared_preferences_plus` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of `shared_preferences_plus`, extend `SharedPreferencesPlusPlatform` with an implementation that performs the platform-specific behavior:

```dart
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

class SharedPreferencesPlusMacOS extends SharedPreferencesPlusPlatform {
  @override
  Future<void> setString(
    String key,
    String value, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    // macOS-specific implementation
  }

  @override
  Future<String?> getString(
    String key, {
    SharedPreferencesPlusOptions options = const SharedPreferencesPlusOptions(),
  }) {
    // macOS-specific implementation
  }

  // ... implement other methods (setInt, getBool, etc.)
}
```

### SharedPreferencesPlusOptions

The `SharedPreferencesPlusOptions` class provides configuration for container-based isolation:

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `String?` | `'SharedPreferencesPlus'` | The name of the storage container/namespace. |

## Related Packages

- [shared_preferences_plus](../shared_preferences_plus/) — App-facing package
- [shared_preferences_plus_android](../shared_preferences_plus_android/) — Android implementation
- [shared_preferences_plus_foundation](../shared_preferences_plus_foundation/) — iOS and macOS implementation
- [shared_preferences_plus_linux](../shared_preferences_plus_linux/) — Linux implementation
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
- [shared_preferences_plus_windows](../shared_preferences_plus_windows/) — Windows implementation
