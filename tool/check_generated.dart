import 'dart:io';

/// Regenerates transport bindings and fails if checked-in output was stale.
Future<void> main() async {
  final dart = Platform.isWindows ? 'dart.bat' : 'dart';
  for (final platform in ['android', 'foundation']) {
    final directory = 'shared_preferences_plus_$platform';
    final outputs = [
      '$directory/lib/src/messages.g.dart',
      if (platform == 'android')
        '$directory/android/src/main/kotlin/com/example/shared_preferences_plus_android/Messages.kt'
      else
        '$directory/darwin/shared_preferences_plus_foundation/Sources/shared_preferences_plus_foundation/Messages.swift',
    ];
    final before = {
      for (final path in outputs) path: await File(path).readAsString(),
    };
    final result = await Process.run(
      dart,
      ['run', 'pigeon', '--input', 'pigeons/messages.dart'],
      workingDirectory: directory,
      runInShell: Platform.isWindows,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    if (result.exitCode != 0) {
      exitCode = result.exitCode;
      return;
    }
    for (final path in outputs) {
      if (await File(path).readAsString() != before[path]) {
        stderr.writeln(
          'Stale Pigeon output: $path. Review and commit the regenerated bindings.',
        );
        exitCode = 1;
      }
    }
  }
}
