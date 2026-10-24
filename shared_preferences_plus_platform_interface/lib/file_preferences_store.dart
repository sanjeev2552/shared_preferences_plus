import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'preferences_codec.dart';
import 'preferences_values.dart';
import 'src/file_lock.dart';
import 'src/serial_executor.dart';

/// Transactional JSON preferences shared by Linux and Windows.
///
/// All readers and writers lock a separate stable file before migration, reading
/// or atomic replacement. Corrupt files are preserved and reported, never reset.
class FilePreferencesStore {
  /// Directory and file factories can be supplied by tests or host applications.
  FilePreferencesStore({
    required this.directoryProvider,
    this.fileFactory = File.new,
    this.lockTimeout = const Duration(seconds: 10),
  });

  /// Returns the application's support directory.
  final Future<String?> Function() directoryProvider;

  /// Creates file handles, allowing storage failures to be injected in tests.
  final File Function(String) fileFactory;

  /// Maximum time to wait for another writer.
  final Duration lockTimeout;
  static final _queues = <String, SerialExecutor>{};

  /// Returns a detached snapshot.
  Future<Map<String, Object>> read(String name) =>
      _transaction(name, (file) => _read(file));

  /// Applies an update to the latest on-disk values under one lock.
  Future<void> update(String name, void Function(Map<String, Object>) change) =>
      _transaction(name, (file) async {
        final values = await _read(file);
        change(values);
        await _replace(file, values);
      });

  /// Clears a container, including a corrupt one, only on explicit request.
  Future<void> clear(String name) =>
      _transaction(name, (file) => _replace(file, {}), migrate: false);

  Future<T> _transaction<T>(
    String name,
    Future<T> Function(File) action, {
    bool migrate = true,
  }) async {
    final directory = await directoryProvider();
    if (directory == null) {
      throw const FileSystemException(
        'Application support directory is unavailable',
      );
    }
    final root = Directory(p.join(directory, 'shared_preferences_plus'));
    await root.create(recursive: true);
    final digest = sha256.convert(utf8.encode(name)).toString();
    final targetPath = p.absolute(p.join(root.path, '$digest.json'));
    final queue = _queues.putIfAbsent(targetPath, SerialExecutor.new);
    return queue.run(() async {
      final lock = await PreferencesFileLock.acquire(
        '$targetPath.lock',
        lockTimeout,
      );
      try {
        final target = fileFactory(targetPath);
        // Only legacy single-component filenames can be inspected. Never follow
        // a legacy symlink or interpret a container name as a relative path.
        if (migrate && !await target.exists() && _safeLegacyName(name)) {
          final legacyPath = p.join(directory, '$name.json');
          if (await FileSystemEntity.type(legacyPath, followLinks: false) ==
              FileSystemEntityType.file) {
            final values = await _read(fileFactory(legacyPath));
            await _replace(target, values);
            // Keep the original as a migration backup; future accesses use target.
          }
        }
        return await action(target);
      } finally {
        lock.release();
      }
    });
  }

  bool _safeLegacyName(String name) =>
      name.isNotEmpty &&
      name != '.' &&
      name != '..' &&
      !name.contains('/') &&
      !name.contains('\\') &&
      !name.contains('\u0000') &&
      !name.contains(RegExp(r'[<>:"|?*]')) &&
      !RegExp(
        r'^(con|prn|aux|nul|com[1-9]|lpt[1-9])(\.|$)',
        caseSensitive: false,
      ).hasMatch(name) &&
      !name.endsWith('.') &&
      !name.endsWith(' ');

  Future<Map<String, Object>> _read(File file) async {
    if (!await file.exists()) return {};
    final contents = await file.readAsString();
    // Empty files were valid in older versions. Nonempty invalid data is retained.
    if (contents.isEmpty) return {};
    try {
      return PreferencesCodec.decode(contents);
    } on FormatException {
      throw FormatException(
        'Invalid preferences in ${file.path}; file preserved. Restore a backup or explicitly clear the container.',
      );
    }
  }

  Future<void> _replace(File file, Map<String, Object?> values) async {
    final contents = PreferencesCodec.encode(copyPreferences(values));
    // Same-directory staging guarantees the rename stays on one filesystem.
    final staging = await Directory(
      p.dirname(file.path),
    ).createTemp('.preferences-');
    final temporary = fileFactory(p.join(staging.path, 'values.json'));
    try {
      await temporary.writeAsString(contents, flush: true);
      // Dart replaces an existing destination file on Windows and POSIX. Never
      // delete the destination first: a failed rename must leave old data intact.
      await temporary.rename(file.path);
    } finally {
      // Cleanup cannot turn a committed write into a reported failure, or mask
      // the original storage error. Readers ignore abandoned staging files.
      try {
        await staging.delete(recursive: true);
      } on FileSystemException {
        /* Best effort. */
      }
    }
  }
}
