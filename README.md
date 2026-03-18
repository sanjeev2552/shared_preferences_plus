# Shared Preferences Plus

A Flutter plugin for reading and writing key-value pairs to persistent storage with support for isolated named containers. Built using the [federated plugin](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) architecture.

> For usage instructions, see the [shared_preferences_plus](./shared_preferences_plus/) package.

## Packages

| Package | Description |
| --- | --- |
| [shared_preferences_plus](./shared_preferences_plus/) | App-facing package that developers depend on |
| [shared_preferences_plus_platform_interface](./shared_preferences_plus_platform_interface/) | Common platform interface for platform implementations |
| [shared_preferences_plus_android](./shared_preferences_plus_android/) | Android implementation |
| [shared_preferences_plus_web](./shared_preferences_plus_web/) | Web implementation |

## Platform Support

| Platform | Status | Storage Backend |
| --- | --- | --- |
| Android | ✅ | SharedPreferences |
| Web | ✅ | localStorage |
| iOS | 🚧 | — |
| macOS | 🚧 | — |
| Linux | 🚧 | — |
| Windows | 🚧 | — |

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

See [LICENSE](./LICENSE) for details.
