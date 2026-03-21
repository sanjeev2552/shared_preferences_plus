# shared_preferences_plus_foundation

The iOS and macOS implementation of the `shared_preferences_plus` plugin.

## Usage

This package is [endorsed](https://dart.dev/tools/pub/dependencies#endorsed-packages), which means you can simply use `shared_preferences_plus` normally. This package will be automatically included in your app when you depend on `shared_preferences_plus`.

```yaml
dependencies:
  shared_preferences_plus:
    git:
      url: https://github.com/sanjeev2552/shared_preferences_plus.git
      path: shared_preferences_plus
```

## Implementation Details

- Uses Apple's native `NSUserDefaults` API for persistent key-value storage.
- Shares a single Darwin source implementation across both iOS and macOS.
- Communicates with native code via [Pigeon](https://pub.dev/packages/pigeon) for type-safe platform channels.
- Supports named containers through `SharedPreferencesPlusOptions` for isolated namespaces.
- Supports retrieving all preferences with the `getAll` method.

## Related Packages

- [shared_preferences_plus](../shared_preferences_plus/) — App-facing package
- [shared_preferences_plus_platform_interface](../shared_preferences_plus_platform_interface/) — Platform interface
- [shared_preferences_plus_android](../shared_preferences_plus_android/) — Android implementation
- [shared_preferences_plus_linux](../shared_preferences_plus_linux/) — Linux implementation
- [shared_preferences_plus_web](../shared_preferences_plus_web/) — Web implementation
- [shared_preferences_plus_windows](../shared_preferences_plus_windows/) — Windows implementation
