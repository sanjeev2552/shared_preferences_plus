# Shared Preferences Plus

A Flutter plugin for reading and writing key-value pairs to persistent storage with support for isolated named containers. Built using the [federated plugin](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) architecture.

> For usage instructions, see the [shared_preferences_plus](./shared_preferences_plus/) package.

## Packages

| Package | Description |
| --- | --- |
| [shared_preferences_plus](./shared_preferences_plus/) | App-facing package that developers depend on |
| [shared_preferences_plus_platform_interface](./shared_preferences_plus_platform_interface/) | Common platform interface for platform implementations |
| [shared_preferences_plus_android](./shared_preferences_plus_android/) | Android implementation |
| [shared_preferences_plus_foundation](./shared_preferences_plus_foundation/) | iOS and macOS implementation |
| [shared_preferences_plus_linux](./shared_preferences_plus_linux/) | Linux implementation |
| [shared_preferences_plus_web](./shared_preferences_plus_web/) | Web implementation |
| [shared_preferences_plus_windows](./shared_preferences_plus_windows/) | Windows implementation |

## Platform Support

| Platform | Status | Storage Backend |
| --- | --- | --- |
| Android | ✅ | SharedPreferences |
| iOS | ✅ | NSUserDefaults |
| macOS | ✅ | NSUserDefaults |
| Web | ✅ | localStorage |
| Linux | ✅ | Atomic JSON file with OS locking (`path_provider_linux`) |
| Windows | ✅ | Atomic JSON file with OS locking (`path_provider_windows`) |

## Development and migration

The packages and examples share one Pub workspace and root lockfile. Start with
`flutter pub get`, then `dart run tool/check.dart`. Browser checks run with
`dart run tool/check.dart --web`.

See [DEVELOPMENT.md](DEVELOPMENT.md) for native/restart checks and release order,
and [MIGRATION.md](MIGRATION.md) for storage compatibility and recovery details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

See [LICENSE](./LICENSE) for details.
