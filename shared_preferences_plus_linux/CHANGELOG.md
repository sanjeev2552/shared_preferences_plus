## 1.1.0

- Use shared atomic file transactions and locks across isolates and processes.
- Migrate safe legacy filenames to hashed container paths while preserving backups.
- Preserve corrupt files and support explicit recovery with clear; add platform-contract tests.
- Require Flutter 3.41.4+ / Dart 3.11.1+ and resolve local development through the Pub workspace.

## 1.0.1

* Update package-level Dart documentation.

## 1.0.0

* Initial release.
* Adds core key-value storage capabilities (`String`, `int`, `double`, `bool`, `List<String>`).
* Adds support for isolated named containers.
* Adds `getAll` method to retrieve all preferences.
* Includes comprehensive in-memory implementation for testing.
