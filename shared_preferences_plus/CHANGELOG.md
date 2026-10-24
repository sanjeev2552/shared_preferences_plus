## 1.1.0

- Serialize initialization, reloads and mutations per container; deduplicate concurrent initialization.
- Copy list inputs and snapshots; retain explicit Web numeric types in the cache.
- Add resettable, isolated mocks, portable container-name validation and regression/restart tests.
- Require Flutter 3.41.4+ / Dart 3.11.1+ and resolve local development through the Pub workspace.

## 1.0.6

- Fixes in swift package manager setup
- Regenerated Messages.swift

## 1.0.1

- Add Swift Package Manager support for iOS and macOS.
- Update dependency versions.

## 1.0.0

- Initial release.
- Adds core key-value storage capabilities (`String`, `int`, `double`, `bool`, `List<String>`).
- Adds support for isolated named containers.
- Adds `getAll` method to retrieve all preferences.
- Includes comprehensive in-memory implementation for testing.
