# shared_preferences_plus_android

The Android implementation of the `shared_preferences_plus` plugin.

## Usage

This package is [endorsed](https://dart.dev/tools/pub/dependencies#endorsed-packages), which means you can simply use `shared_preferences_plus` normally. This package will be automatically included in your app when you depend on `shared_preferences_plus`.

```yaml
dependencies:
  shared_preferences_plus:
    git:
      url: https://github.com/<owner>/shared_preferences_plus.git
      path: shared_preferences_plus
```

## Implementation Details

- Uses Android's native `SharedPreferences` API for persistent key-value storage.
- Communicates with native code via [Pigeon](https://pub.dev/packages/pigeon) for type-safe platform channels.
- Supports named containers through `SharedPreferencesPlusOptions` for isolated namespaces.

## Related Packages

- [shared_preferences_plus](../shared_preferences_plus/) — App-facing package
- [shared_preferences_plus_platform_interface](../shared_preferences_plus_platform_interface/) — Platform interface
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
