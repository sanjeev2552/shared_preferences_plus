## 1.1.0

- Add typed snapshots, a versioned JSON codec and defensive preference copies.
- Add shared transactional desktop storage with process/isolate locks, safe migration and atomic replacement.
- Isolate mock instances and add shared platform, corruption, concurrency and migration tests.
- Require Flutter 3.41.4+ / Dart 3.11.1+ and resolve local development through the Pub workspace.

## 1.0.1

* Update package-level Dart documentation.

## 1.0.0

* Initial release.
* Adds core key-value storage capabilities (`String`, `int`, `double`, `bool`, `List<String>`).
* Adds support for isolated named containers.
* Adds `getAll` method to retrieve all preferences.
* Includes comprehensive in-memory implementation for testing.
