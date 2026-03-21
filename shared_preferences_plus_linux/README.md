# shared_preferences_plus_linux

The Linux implementation of the `shared_preferences_plus` plugin.

## Usage

This package is [endorsed](https://dart.dev/tools/pub/dependencies#endorsed-packages), which means you can simply use `shared_preferences_plus` normally. This package will be automatically included in your app when you depend on `shared_preferences_plus`.

```yaml
dependencies:
  shared_preferences_plus: ^1.0.0
```

## Implementation Details

- Uses the local file system to store data persistently as JSON files (`<container_name>.json`).
- Defers to `path_provider_linux` to safely retrieve XDG base directories.
- Built strictly in Dart (via FFI through path_provider), removing the need for compiling C++ plugins.
- Supports named containers through `SharedPreferencesPlusOptions` for isolated namespaces.
- Supports retrieving all preferences with the `getAll` method.

## Related Packages

- [shared_preferences_plus](../shared_preferences_plus/) — App-facing package
- [shared_preferences_plus_platform_interface](../shared_preferences_plus_platform_interface/) — Platform interface
- [shared_preferences_plus_android](../shared_preferences_plus_android/) — Android implementation
- [shared_preferences_plus_foundation](../shared_preferences_plus_foundation/) — iOS and macOS implementation
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
- [shared_preferences_plus_windows](../shared_preferences_plus_windows/) — Windows implementation
