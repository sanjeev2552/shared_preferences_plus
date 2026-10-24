import 'dart:convert';
import 'dart:io';

/// Repeatable local/CI verification. Run from the repository root.
Future<void> main(List<String> args) async {
  final flutter = Platform.isWindows ? 'flutter.bat' : 'flutter';
  final dart = Platform.isWindows ? 'dart.bat' : 'dart';
  final root = Directory.current.path;
  Future<void> run(
    String command,
    List<String> arguments, {
    String? directory,
    String? description,
  }) async {
    stdout.writeln(description ?? '\n> $command ${arguments.join(' ')}');
    final process = await Process.start(
      command,
      arguments,
      workingDirectory: directory ?? root,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    final code = await process.exitCode;
    if (code != 0) {
      throw ProcessException(command, arguments, 'Verification failed', code);
    }
  }

  if (args.isNotEmpty && args.first == '--integration') {
    if (args.length != 2) {
      throw ArgumentError(
        'Usage: dart run tool/check.dart --integration <device>',
      );
    }
    final device = args[1];
    final token = DateTime.now().microsecondsSinceEpoch.toString();
    final example = '$root/shared_preferences_plus/example';
    await run(flutter, [
      'test',
      '--no-pub',
      'integration_test/plugin_integration_test.dart',
      '-d',
      device,
    ], directory: example);
    final desktop = const {'macos', 'linux', 'windows'}.contains(device);
    if (desktop) {
      for (final phase in ['write', 'read']) {
        await run(flutter, [
          'test',
          '--no-pub',
          'integration_test/restart_${phase}_test.dart',
          '-d',
          device,
          '--dart-define=PREFERENCES_RESTART_TOKEN=$token',
        ], directory: example);
      }
    } else {
      final discovery = await Process.run(flutter, [
        'devices',
        '--machine',
      ], runInShell: Platform.isWindows);
      if (discovery.exitCode != 0) throw StateError('${discovery.stderr}');
      final details = (jsonDecode(discovery.stdout as String) as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((item) => item['id'] == device);
      final ios = details['targetPlatform'] == 'ios';
      if (!ios &&
          !(details['targetPlatform'] as String).startsWith('android')) {
        throw UnsupportedError(
          'Restart checks require desktop, Android or an iOS simulator.',
        );
      }
      if (ios && details['emulator'] != true) {
        throw UnsupportedError(
          'Restart checks support iOS simulators. Use a simulator device ID.',
        );
      }
      // flutter test uninstalls mobile apps on completion. Drive can leave the
      // writer installed; stop it explicitly to preserve data for the reader.
      try {
        await run(flutter, [
          'drive',
          '--no-pub',
          '--driver=test_driver/integration_test.dart',
          '--target=integration_test/restart_write_test.dart',
          '--keep-app-running',
          '-d',
          device,
          '--dart-define=PREFERENCES_RESTART_TOKEN=$token',
        ], directory: example);
      } finally {
        if (ios) {
          await run('xcrun', [
            'simctl',
            'terminate',
            device,
            'com.example.sharedPreferencesPlusExample',
          ]);
        } else {
          await run('adb', [
            '-s',
            device,
            'shell',
            'am',
            'force-stop',
            'com.example.shared_preferences_plus_example',
          ]);
        }
      }
      await run(flutter, [
        'drive',
        '--no-pub',
        '--driver=test_driver/integration_test.dart',
        '--target=integration_test/restart_read_test.dart',
        '-d',
        device,
        '--dart-define=PREFERENCES_RESTART_TOKEN=$token',
      ], directory: example);
    }
    return;
  }
  if (args.contains('--web')) {
    await run(flutter, [
      'test',
      '--no-pub',
      '--platform',
      'chrome',
    ], directory: '$root/shared_preferences_plus_web');
    await run(flutter, [
      'test',
      '--no-pub',
      '--platform',
      'chrome',
      'test/public_web_test.dart',
    ], directory: '$root/shared_preferences_plus');
    return;
  }
  await run(flutter, ['analyze', '--no-pub']);
  await run(flutter, [
    'test',
    '--no-pub',
    '--reporter',
    'expanded',
    'shared_preferences_plus/test',
    'shared_preferences_plus_platform_interface/test',
    'shared_preferences_plus_android/test',
    'shared_preferences_plus_foundation/test',
    'shared_preferences_plus_linux/test',
    'shared_preferences_plus_windows/test',
    'shared_preferences_plus/example/test',
    'shared_preferences_plus_android/example/test',
    'shared_preferences_plus_platform_interface/example/test',
  ]);
  // Generated bindings must retain Pigeon's own formatting.
  const excluded = {
    '.git',
    '.dart_tool',
    '.kotlin',
    '.symlinks',
    '.swiftpm',
    'build',
    'ephemeral',
    'Pods',
    'coverage',
  };
  Iterable<File> sourcesIn(Directory directory) sync* {
    for (final entry in directory.listSync(followLinks: false)) {
      if (entry is Directory) {
        final name = entry.uri.pathSegments
            .where((part) => part.isNotEmpty)
            .last;
        if (!excluded.contains(name)) yield* sourcesIn(entry);
      } else if (entry is File &&
          entry.path.endsWith('.dart') &&
          !entry.path.endsWith('.g.dart')) {
        yield entry;
      }
    }
  }

  final sources = sourcesIn(Directory(root)).map((file) => file.path).toList()
    ..sort();
  for (var i = 0; i < sources.length; i += 20) {
    await run(dart, [
      'format',
      '--output=none',
      '--set-exit-if-changed',
      ...sources.skip(i).take(20),
    ], description: '> Check Dart formatting (batch ${i ~/ 20 + 1})');
  }
  if (Platform.isMacOS) await run(dart, ['run', 'tool/test_foundation.dart']);
}
