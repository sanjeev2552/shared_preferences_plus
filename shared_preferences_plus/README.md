# shared_preferences_plus

A Flutter plugin for reading and writing key-value pairs to persistent storage with support for isolated named containers.

## Features

- 🔑 **Simple key-value storage** — Read and write string data with a clean, intuitive API.
- 📦 **Container support** — Create isolated namespaces using named containers to keep data organized and separated.
- 🌐 **Cross-platform** — Works on Android (SharedPreferences), iOS & macOS (NSUserDefaults), and Web (localStorage).

## Installation

```yaml
dependencies:
  shared_preferences_plus:
    git:
      url: https://github.com/<owner>/shared_preferences_plus.git
      path: shared_preferences_plus
```

## Usage

### Basic

```dart
import 'package:shared_preferences_plus/shared_preferences_plus.dart';

final prefs = SharedPreferencesPlus();

// Write a string value
await prefs.setString('key', 'value');

// Read a string value
final value = await prefs.getString('key'); // 'value'
```

### Named Containers

Use `SharedPreferencesPlusOptions` to create isolated namespaces:

```dart
final userPrefs = SharedPreferencesPlus(
  options: SharedPreferencesPlusOptions(name: 'user_settings'),
);

final appPrefs = SharedPreferencesPlus(
  options: SharedPreferencesPlusOptions(name: 'app_config'),
);

// Data is stored in separate, isolated containers
await userPrefs.setString('theme', 'dark');
await appPrefs.setString('theme', 'v2');

final userTheme = await userPrefs.getString('theme'); // 'dark'
final appTheme = await appPrefs.getString('theme');   // 'v2'
```

> If no `name` is provided, the default container name `SharedPreferencesPlus` is used.

## Supported Platforms

| Platform | Status |
| --- | --- |
| [Android](../shared_preferences_plus_android/) | ✅ |
| [iOS](../shared_preferences_plus_foundation/) | ✅ |
| [macOS](../shared_preferences_plus_foundation/) | ✅ |
| [Web](../shared_preferences_plus_web/) | ✅ |

## Related Packages

- [shared_preferences_plus_platform_interface](../shared_preferences_plus_platform_interface/) — Platform interface
- [shared_preferences_plus_android](../shared_preferences_plus_android/) — Android implementation
- [shared_preferences_plus_foundation](../shared_preferences_plus_foundation/) — iOS and macOS implementation
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
