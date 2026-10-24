# Shared Preferences Plus example

This application demonstrates cached reads, writes and isolated named containers
on Android, iOS, macOS, Linux, Windows and Web.

From the repository root:

```sh
flutter pub get
cd shared_preferences_plus/example
flutter run
```

The integration suite checks all supported value types, reload behavior, concurrent
writes and container isolation. Run the separate-process restart checks using
`dart run tool/check.dart --integration <device-id>` from the repository root.
See [DEVELOPMENT.md](../../DEVELOPMENT.md) for browser tests, Apple dependency
managers, native tests and CI. See [MIGRATION.md](../../MIGRATION.md) before
upgrading an application with existing preferences.
