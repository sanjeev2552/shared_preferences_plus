## 1.1.0

- Use typed JSON envelopes to preserve double identity through JavaScript round trips; read legacy maps.
- Return actionable asynchronous browser-storage errors and preserve malformed data.
- Add injectable storage, safe-integer checks and real Chrome persistence/type tests.
- Require Flutter 3.41.4+ / Dart 3.11.1+ and resolve local development through the Pub workspace.

## 1.0.1

* Update package-level Dart documentation.

## 1.0.0

* Initial release.
* Adds core key-value storage capabilities (`String`, `int`, `double`, `bool`, `List<String>`).
* Adds support for isolated named containers.
* Adds `getAll` method to retrieve all preferences.
* Includes comprehensive in-memory implementation for testing.
