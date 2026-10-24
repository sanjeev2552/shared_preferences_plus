# shared_preferences_plus

A Flutter plugin for reading and writing key-value pairs to persistent storage with support for isolated named containers.

## Features

- 🔑 **Simple key-value storage** — Read and write standard data types (`String`, `int`, `double`, `bool`, `List<String>`) with a clean, intuitive API.
- 📦 **Container support** — Create isolated namespaces using named containers to keep data organized and separated.
- 🌐 **Cross-platform** — Works on Android (SharedPreferences), iOS & macOS (NSUserDefaults), Web (localStorage), and Windows & Linux (local JSON file).

## Installation

```yaml
dependencies:
  shared_preferences_plus: ^1.1.0
```

## Usage

### Basic

Call `SharedPreferencesPlus.getInstance()` before any reads to initialize the in-memory cache.
Reads are synchronous and will throw `StateError` if the cache has not been loaded.

```dart
import 'package:shared_preferences_plus/shared_preferences_plus.dart';

final prefs = await SharedPreferencesPlus.getInstance();

// Write values
await prefs.setString('key', 'value');
await prefs.setInt('counter', 10);
await prefs.setBool('is_active', true);

// Read values
final value = prefs.getString('key'); // 'value'
final counter = prefs.getInt('counter'); // 10
final isActive = prefs.getBool('is_active'); // true

// Read all values
final allPrefs = prefs.getAll(); // {'key': 'value', 'counter': 10, 'is_active': true}
```

### Named Containers

Use `SharedPreferencesPlusOptions` to create isolated namespaces:

```dart
final userPrefs = await SharedPreferencesPlus.getInstance(
  options: SharedPreferencesPlusOptions(name: 'user_settings'),
);

final appPrefs = await SharedPreferencesPlus.getInstance(
  options: SharedPreferencesPlusOptions(name: 'app_config'),
);

// Data is stored in separate, isolated containers
await userPrefs.setString('theme', 'dark');
await appPrefs.setString('theme', 'v2');

final userTheme = userPrefs.getString('theme'); // 'dark'
final appTheme = appPrefs.getString('theme');   // 'v2'
```

> If no `name` is provided, the default container name `SharedPreferencesPlus` is used.

## Cache and storage behavior

Operations run in call order per container within an isolate. Writes update the
cache only after the platform operation succeeds. Input lists, returned lists and
`getAll()` snapshots are detached copies.

```dart
await prefs.reload(); // Observe changes made by another isolate, process or tab.
final keys = prefs.getKeys();
final exists = prefs.containsKey('counter');
await prefs.remove('counter');
await prefs.clear(); // Clears only this named container.
```

Container names must contain 1–128 UTF-8 bytes, without path separators or NUL,
and cannot be `.` or `..`. The default name remains `SharedPreferencesPlus`.
Web integers must fit the JavaScript safe integer range. Different browser tabs
need application-level coordination for concurrent writes.

Requires Flutter 3.41.4+ and Dart 3.11.1+. Android requires API 24+, iOS 13+,
and macOS 10.15+. The repository examples use newer Apple deployment targets
for current Xcode compatibility.

Native preference writes can flush asynchronously; a completed setter does not
guarantee survival after sudden power loss. Preferences are unencrypted and are
intended for configuration rather than secrets or critical records.

Version 1.1.0 reads legacy storage and uses typed encodings for new writes.
See the repository's [migration guide](https://github.com/sanjeev2552/shared_preferences_plus/blob/main/MIGRATION.md)
for ambiguous legacy Android lists, desktop backup files, corruption recovery,
and downgrade limitations. See [development instructions](https://github.com/sanjeev2552/shared_preferences_plus/blob/main/DEVELOPMENT.md)
for shared tests, native builds and restart checks.

## Support

If you like this package, consider supporting it by:

1. Starring the repository on [GitHub](https://github.com/sanjeev2552/shared_preferences_plus) ⭐️
2. Liking the package on [pub.dev](https://pub.dev/packages/shared_preferences_plus) 👍
