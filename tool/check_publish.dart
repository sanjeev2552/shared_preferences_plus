import 'dart:io';

/// Validates publish archives from an isolated source copy. Never uploads them.
Future<void> main() async {
  final temporary = await Directory.systemTemp.createTemp(
    'preferences-publish-',
  );
  final root = Directory.current;
  final dart = Platform.isWindows ? 'dart.bat' : 'dart';
  final flutter = Platform.isWindows ? 'flutter.bat' : 'flutter';
  try {
    final listing = await Process.run('git', [
      'ls-files',
      '--cached',
      '--others',
      '--exclude-standard',
      '-z',
    ]);
    if (listing.exitCode != 0) throw StateError('${listing.stderr}');
    for (final path
        in (listing.stdout as String)
            .split('\u0000')
            .where((path) => path.isNotEmpty)) {
      final source = File('${root.path}/$path');
      if (!await source.exists()) continue;
      final destination = File('${temporary.path}/$path');
      await destination.parent.create(recursive: true);
      await source.copy(destination.path);
    }
    final resolution = await Process.run(
      flutter,
      ['pub', 'get', '--offline'],
      workingDirectory: temporary.path,
      runInShell: Platform.isWindows,
    );
    if (resolution.exitCode != 0) {
      throw StateError('${resolution.stdout}\n${resolution.stderr}');
    }
    for (final name in [
      'platform_interface',
      'android',
      'foundation',
      'linux',
      'web',
      'windows',
      '',
    ]) {
      final package = 'shared_preferences_plus${name.isEmpty ? '' : '_$name'}';
      final result = await Process.run(
        dart,
        ['pub', 'publish', '--dry-run'],
        workingDirectory: '${temporary.path}/$package',
        runInShell: Platform.isWindows,
      );
      if (result.exitCode != 0) {
        stderr.writeln(
          '$package packaging check failed:\n${result.stdout}\n${result.stderr}',
        );
        exitCode = result.exitCode;
      } else {
        stdout.writeln('$package: publish dry-run passed');
      }
    }
  } finally {
    await temporary.delete(recursive: true);
  }
}
