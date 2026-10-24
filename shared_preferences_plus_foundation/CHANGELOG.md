## 1.1.0

- Preserve double identity, normalize decoded lists and scope reads/clear to the named persistent domain.
- Correct Pigeon channel names and include the UserDefaults privacy manifest through CocoaPods and Swift Package Manager.
- Refresh pod metadata and add codec, native storage and restart coverage.
- Require Flutter 3.41.4+ / Dart 3.11.1+ and resolve local development through the Pub workspace.

## 1.0.6

- Fixes in swift package manager setup
- Regenerated Messages.swift

## 1.0.1

* Add Swift Package Manager support for iOS and macOS.
* Update package-level Dart documentation.

## 1.0.0

* Initial release.
* Adds core key-value storage capabilities (`String`, `int`, `double`, `bool`, `List<String>`).
* Adds support for isolated named containers.
* Adds `getAll` method to retrieve all preferences.
* Includes comprehensive in-memory implementation for testing.
