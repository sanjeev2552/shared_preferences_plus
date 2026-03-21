# shared_preferences_plus

A Flutter plugin for reading and writing key-value pairs to persistent storage with support for isolated named containers.

## Features

- 🔑 **Simple key-value storage** — Read and write standard data types (`String`, `int`, `double`, `bool`, `List<String>`) with a clean, intuitive API.
- 📦 **Container support** — Create isolated namespaces using named containers to keep data organized and separated.
- 🌐 **Cross-platform** — Works on Android (SharedPreferences), iOS & macOS (NSUserDefaults), Web (localStorage), and Windows & Linux (local JSON file).

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

Call `SharedPreferencesPlus.load()` before any reads to initialize the in-memory cache.
Reads are synchronous and will throw `StateError` if the cache has not been loaded.

```dart
import 'package:shared_preferences_plus/shared_preferences_plus.dart';

final prefs = await SharedPreferencesPlus.load();

// Write values
await prefs.setString('key', 'value');
await prefs.setInt('counter', 10);
await prefs.setBool('is_active', true);

// Read values
final value = prefs.getString('key'); // 'value'
final counter = prefs.getInt('counter'); // 10
final isActive = prefs.getBool('is_active'); // true
```

### Named Containers

Use `SharedPreferencesPlusOptions` to create isolated namespaces:

```dart
final userPrefs = await SharedPreferencesPlus.load(
  options: SharedPreferencesPlusOptions(name: 'user_settings'),
);

final appPrefs = await SharedPreferencesPlus.load(
  options: SharedPreferencesPlusOptions(name: 'app_config'),
);

// Data is stored in separate, isolated containers
await userPrefs.setString('theme', 'dark');
await appPrefs.setString('theme', 'v2');

final userTheme = userPrefs.getString('theme'); // 'dark'
final appTheme = appPrefs.getString('theme');   // 'v2'
```

> If no `name` is provided, the default container name `SharedPreferencesPlus` is used.

## Supported Platforms

| Platform | Status |
| --- | --- |
| [Android](../shared_preferences_plus_android/) | ✅ |
| [iOS](../shared_preferences_plus_foundation/) | ✅ |
| [Linux](../shared_preferences_plus_linux/) | ✅ |
| [macOS](../shared_preferences_plus_foundation/) | ✅ |
| [Web](../shared_preferences_plus_web/) | ✅ |
| [Windows](../shared_preferences_plus_windows/) | ✅ |

## Related Packages

- [shared_preferences_plus_platform_interface](../shared_preferences_plus_platform_interface/) — Platform interface
- [shared_preferences_plus_android](../shared_preferences_plus_android/) — Android implementation
- [shared_preferences_plus_foundation](../shared_preferences_plus_foundation/) — iOS and macOS implementation
- [shared_preferences_plus_linux](../shared_preferences_plus_linux/) — Linux implementation
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
- [shared_preferences_plus_windows](../shared_preferences_plus_windows/) — Windows implementation
