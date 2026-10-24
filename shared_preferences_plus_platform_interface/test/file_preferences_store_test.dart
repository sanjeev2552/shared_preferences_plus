import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_platform_interface/src/file_lock.dart';

Future<String> dartExecutable() async {
  var directory = Directory.current;
  while (true) {
    final config = File(
      p.join(directory.path, '.dart_tool', 'package_config.json'),
    );
    if (await config.exists()) {
      final data =
          jsonDecode(await config.readAsString()) as Map<String, dynamic>;
      final flutter = (data['packages'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((entry) => entry['name'] == 'flutter');
      final flutterPackage = config.uri
          .resolve(flutter['rootUri'] as String)
          .toFilePath();
      return p.normalize(
        p.join(
          flutterPackage,
          '..',
          '..',
          'bin',
          'cache',
          'dart-sdk',
          'bin',
          Platform.isWindows ? 'dart.exe' : 'dart',
        ),
      );
    }
    if (directory.parent.path == directory.path) {
      throw StateError('No workspace package_config.json found');
    }
    directory = directory.parent;
  }
}

Future<void> writeFromIsolate(String directory, String prefix) async {
  final store = FilePreferencesStore(directoryProvider: () async => directory);
  for (var i = 0; i < 15; i++) {
    await store.update('concurrent', (values) {
      values['$prefix-$i'] = i;
    });
  }
}

void main() {
  late Directory directory;
  late FilePreferencesStore store;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('preferences-store-');
    store = FilePreferencesStore(directoryProvider: () async => directory.path);
  });
  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test(
    'serializes simultaneous updates through independent store instances',
    () async {
      final other = FilePreferencesStore(
        directoryProvider: () async => directory.path,
      );
      await Future.wait(
        List.generate(
          40,
          (i) => (i.isEven ? store : other).update('concurrent', (values) {
            values['key$i'] = i;
          }),
        ),
      );
      expect((await store.read('concurrent')).length, 40);
    },
  );
  test('locks updates across isolates in the same process', () async {
    final path = directory.path;
    await Future.wait(
      List.generate(
        3,
        (i) => Isolate.run(() => writeFromIsolate(path, 'isolate$i')),
      ),
    );
    expect((await store.read('concurrent')).length, 45);
  });
  test('locks updates across independent processes', () async {
    final packageRoot =
        Directory.current.path.endsWith(
          'shared_preferences_plus_platform_interface',
        )
        ? Directory.current
        : Directory('shared_preferences_plus_platform_interface');
    final worker = p.join(
      packageRoot.absolute.path,
      'tool',
      'storage_worker.dart',
    );
    final results = await Future.wait(
      List.generate(
        3,
        (i) async => Process.run(await dartExecutable(), [
          worker,
          directory.path,
          'process$i',
        ]),
      ),
    );
    for (final result in results) {
      expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    }
    expect((await store.read('concurrent')).length, 45);
  }, timeout: const Timeout(Duration(minutes: 2)));
  test(
    'times out without stealing an active lock and releases normally',
    () async {
      final lockPath = p.join(directory.path, 'owner.lock');
      final first = await PreferencesFileLock.acquire(
        lockPath,
        const Duration(seconds: 1),
      );
      await expectLater(
        PreferencesFileLock.acquire(lockPath, const Duration(milliseconds: 30)),
        throwsA(isA<FileSystemException>()),
      );
      first.release();
      final second = await PreferencesFileLock.acquire(
        lockPath,
        const Duration(seconds: 1),
      );
      second.release();
    },
  );
  test('migrates only safe legacy files and leaves a backup', () async {
    final legacy = File(p.join(directory.path, 'legacy.json'));
    await legacy.writeAsString('{"text":"old","list":["a"],"double":1.5}');
    expect(await store.read('legacy'), {
      'text': 'old',
      'list': ['a'],
      'double': 1.5,
    });
    await store.update('legacy', (values) {
      values['new'] = true;
    });
    expect(
      await legacy.readAsString(),
      '{"text":"old","list":["a"],"double":1.5}',
    );
    expect((await store.read('legacy'))['new'], isTrue);
  });
  test('container names never become filesystem paths', () async {
    for (final name in [
      '../escape',
      '/absolute',
      r'C:\outside',
      'a/b',
      '',
      'name 🐦',
      'x' * 1000,
    ]) {
      await store.update(name, (values) {
        values['name'] = name;
      });
      expect((await store.read(name))['name'], name);
    }
    final files = await directory.list().toList();
    expect(files.length, 1);
    expect(p.basename(files.single.path), 'shared_preferences_plus');
  });
  test('preserves corrupt data and requires explicit clearing', () async {
    await store.update('broken', (values) {
      values['key'] = 'value';
    });
    final files = await Directory(
      p.join(directory.path, 'shared_preferences_plus'),
    ).list().where((e) => e.path.endsWith('.json')).toList();
    final file = File(files.single.path);
    await file.writeAsString('{broken');
    await expectLater(store.read('broken'), throwsFormatException);
    await expectLater(
      store.update('broken', (values) {
        values['new'] = true;
      }),
      throwsFormatException,
    );
    expect(await file.readAsString(), '{broken');
    await store.clear('broken');
    expect(await store.read('broken'), isEmpty);
  });
  test(
    'failed replacement leaves the previous committed file intact',
    () async {
      await store.update('failure', (values) {
        values['key'] = 'original';
      });
      final failing = FilePreferencesStore(
        directoryProvider: () async => directory.path,
        fileFactory: (path) =>
            path.endsWith('values.json') ? RenameFailureFile(path) : File(path),
      );
      await expectLater(
        failing.update('failure', (values) {
          values['key'] = 'lost';
        }),
        throwsA(isA<FileSystemException>()),
      );
      expect((await store.read('failure'))['key'], 'original');
      expect(
        await Directory(p.join(directory.path, 'shared_preferences_plus'))
            .list()
            .where((e) => p.basename(e.path).startsWith('.preferences-'))
            .length,
        0,
      );
    },
  );
  test('reports unavailable support directories', () async {
    final unavailable = FilePreferencesStore(
      directoryProvider: () async => null,
    );
    await expectLater(
      unavailable.read('default'),
      throwsA(isA<FileSystemException>()),
    );
  });

  test(
    'supports support-directory paths longer than the Windows legacy limit',
    () async {
      final path = p.join(directory.path, 'a' * 100, 'b' * 100);
      final nested = FilePreferencesStore(directoryProvider: () async => path);
      await nested.update('long-path', (values) {
        values['key'] = 'value';
      });
      expect(await nested.read('long-path'), {'key': 'value'});
    },
  );

  test(
    'process termination releases the OS lock without stale-file recovery',
    () async {
      final packageRoot =
          Directory.current.path.endsWith(
            'shared_preferences_plus_platform_interface',
          )
          ? Directory.current
          : Directory('shared_preferences_plus_platform_interface');
      final worker = p.join(
        packageRoot.absolute.path,
        'tool',
        'storage_worker.dart',
      );
      final lockPath = p.join(directory.path, 'crash.lock');
      final process = await Process.start(await dartExecutable(), [
        worker,
        lockPath,
        'hold',
      ]);
      try {
        expect(
          await process.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .first
              .timeout(const Duration(seconds: 30)),
          'locked',
        );
        process.kill();
        await process.exitCode;
        final lock = await PreferencesFileLock.acquire(
          lockPath,
          const Duration(seconds: 2),
        );
        lock.release();
      } finally {
        process.kill();
        await process.exitCode;
      }
    },
  );

  test('explicit clear can recover a corrupt legacy container', () async {
    final legacy = File(p.join(directory.path, 'legacy_broken.json'));
    await legacy.writeAsString('{broken');
    await expectLater(store.read('legacy_broken'), throwsFormatException);
    await store.clear('legacy_broken');
    expect(await store.read('legacy_broken'), isEmpty);
    expect(await legacy.readAsString(), '{broken');
  });
}

class RenameFailureFile implements File {
  RenameFailureFile(this.path);
  @override
  final String path;
  @override
  Future<File> writeAsString(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) => File(
    path,
  ).writeAsString(contents, mode: mode, encoding: encoding, flush: flush);
  @override
  Future<File> rename(String newPath) async =>
      throw FileSystemException('Injected rename failure', path);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
