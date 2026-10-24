# Storage changes in 1.1.0

Existing supported values remain readable. Successful new writes use explicitly
typed encodings. Older plugin versions cannot reliably read the new encodings;
upgrades are supported, downgrades require an application-managed export/restore.
Back up important preferences before changing the storage implementation.

Container names are now validated in release builds on every Dart implementation:
1–128 UTF-8 bytes, excluding `/`, `\`, NUL and the names `.` and `..`. The default
is still `SharedPreferencesPlus`. Names outside this portable set must be renamed
by an application migration before using the public API.

## Android

New strings, ordered string lists and doubles use a versioned, typed StringSet
envelope in the same SharedPreferences entry. This keeps raw strings separate
from lists, preserves duplicate/empty list elements and stores full double
precision. Integers and booleans retain native encodings.

Legacy floats and strings remain readable without rewriting on reads. The old
delimiter format is inherently ambiguous: a raw string containing `/0001u`
looks like a list, and `[]`, `[""]` and an empty string share an encoding.
`getAll()` preserves the previous delimiter heuristic for legacy values; raw
single-item legacy lists appear as strings. Where the application knows the
intended type, rewrite the value using the appropriate setter. Lost float
precision and list boundaries cannot be reconstructed automatically.

## Apple

New doubles use a tagged property-list dictionary so `1.0` and `-0.0` retain
their type. Existing property-list values remain readable. Legacy numbers use
their stored NSNumber type rather than numerical rounding; an integer already
coerced by UserDefaults cannot reveal whether the application originally meant
a double. Rewrite known values with `setDouble` when necessary.

Reads and clear operations now address only the named persistent domain,
excluding inherited/registered defaults. The privacy manifest declares app-local
UserDefaults access and is included by CocoaPods and Swift Package Manager; see
[Apple's required-reason API documentation](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api).
Applications using App Groups must review their own reason declarations.

## Linux and Windows

Containers now live in `shared_preferences_plus/<SHA-256-of-name>.json` under the
application support directory. Only safe, single-component legacy filenames are
considered for migration; symlinks and paths outside that directory are ignored.
The first access copies valid legacy data into the new format and retains the
old file as a backup. Subsequent reads use the new file. Do not run old and new
application versions concurrently and expect their stores to synchronize.

Readers and writers coordinate through persistent OS lock files, including
across isolates/processes. Locks release when the owning process exits. Do not
delete lock files while applications are running. A flushed staging file replaces
the committed file by rename. Failed writes preserve the last committed file;
power-loss durability still depends on the filesystem. A killed process may
leave an unused staging directory, which readers ignore.

Malformed JSON is retained and reported as `FormatException`; writes do not
silently erase it. Restore the file from a backup or explicitly call `clear()`
for that container. Clear also permits recovery from corrupt legacy files.

## Web

Each existing localStorage container key is retained. Legacy JSON maps remain
readable and are upgraded on the next successful write. Typed envelopes preserve
whole-valued doubles and special double values across JavaScript JSON round trips.
Web integers are restricted to the safe integer range
`-9007199254740991` through `9007199254740991`. Original type distinctions already
lost in legacy JSON cannot be recovered.

Malformed data is preserved and raises `FormatException`; explicitly clear the
container to reset it. Browser storage failures arrive through the returned
Future as `PlatformException` with `storage-full` or `storage-unavailable` codes.
Different browser tabs do not share a transaction lock; coordinate concurrent
writes at application level.

## Cache and durability

Initialization, reload, write, remove and clear operations execute in call order
per container within an isolate. Concurrent initialization shares one load.
Failed operations do not poison the queue or update the cache. Cache invalidation
also invalidates in-flight results. Lists and snapshots are copied defensively.

Caches remain isolate-local. Call `reload()` to observe writes by another isolate,
engine, process or browser tab. A completed native setter means the platform API
accepted the value, not that it survived sudden power loss. Preferences are
unencrypted configuration storage; use appropriate secure storage for secrets.
