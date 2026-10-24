# Development

The repository uses one Dart Pub workspace, including examples and the private
test-support package. All plugin dependencies resolve to this checkout. Commit
the root `pubspec.lock`; Pub removes obsolete member lockfiles during resolution.
Use Flutter 3.41.4 or newer with Dart 3.11.1 or newer.

```sh
flutter pub get
dart run tool/check.dart
dart run tool/check.dart --web
dart run tool/check_generated.dart
dart run tool/check_publish.dart
```

The default check runs analysis, platform contracts, cache/concurrency/migration
tests, example widget tests, formatting, and native Swift storage checks on macOS.
Chrome is required for `--web`. The storage suite starts independent Dart
processes and isolates to exercise real filesystem locks. The shared Pigeon host
uses the real codecs; native Android/Swift checks cover the storage implementations.

The Pigeon version is pinned. To intentionally update generated bindings, run
`dart run pigeon --input pigeons/messages.dart` from each native package, then
review Dart and native output together. Generated bindings keep Pigeon's formatting.

## Native and restart checks

```sh
# Run the Android SharedPreferences tests with Robolectric.
cd shared_preferences_plus_android/example/android
./gradlew :shared_preferences_plus_android:testDebugUnitTest
```

From the repository root, use a device from `flutter devices`:

```sh
dart run tool/check.dart --integration macos
dart run tool/check.dart --integration linux
dart run tool/check.dart --integration windows
dart run tool/check.dart --integration emulator-5554
```

Each command runs the full contract, launches a writer application, terminates it,
and launches a separate reader application. On mobile, the writer uses Flutter
Driver with `--keep-app-running`, followed by an explicit process stop; ordinary
`flutter test` uninstalls mobile apps and would erase the data being tested. A unique run token prevents a stale
value from satisfying the restart check. Native preference flushing is asynchronous;
the writer permits a normal flush before graceful exit. These tests do not claim
power-loss durability.

On macOS, explicitly test both Apple dependency managers:

```sh
dart run tool/build_apple.dart pods macos --integration
dart run tool/build_apple.dart spm macos --integration
dart run tool/build_apple.dart pods ios --integration
dart run tool/build_apple.dart spm ios --integration
```

Omit `--integration` for build-only validation. The helper temporarily selects the
manager in the example's pubspec, restores it afterward, and boots/shuts down an
iPhone simulator when needed. It leaves an already booted simulator running.
The examples target iOS 15/macOS 12 for current Xcode; the library retains its
iOS 13/macOS 10.15 deployment minimums.

CI runs host tests on Linux, Windows and macOS; Chrome tests; real desktop and
Android-emulator integration; and iOS/macOS integration with both Apple managers.
Platform jobs must pass before releasing. A local macOS pass does not substitute
for Windows/Linux CI.

## Release order

All packages are prepared as 1.1.0. `dart run tool/check_publish.dart` validates
all seven publish archives from a temporary source copy, without uploading them. Publish the platform interface first, then
Android/Foundation/Linux/Web/Windows, then the app-facing package. Run
`dart pub publish --dry-run` inside each package before publishing. Never publish
the workspace root or test-support package. See [MIGRATION.md](MIGRATION.md) for
format compatibility and recovery behavior.
