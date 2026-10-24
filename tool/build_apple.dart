import 'dart:convert';
import 'dart:io';

/// Exercises CocoaPods and Swift Package Manager without changing global Flutter
/// settings. The temporary project preference is restored even on failure.
Future<void> main(List<String> args) async {
  if (!Platform.isMacOS ||
      args.length < 2 ||
      !['pods', 'spm'].contains(args[0]) ||
      !['macos', 'ios'].contains(args[1])) {
    throw ArgumentError(
      'Usage: dart run tool/build_apple.dart <pods|spm> <macos|ios> [--integration]',
    );
  }
  final root = Directory.current.path;
  final pubspec = File('shared_preferences_plus/example/pubspec.yaml');
  final original = await pubspec.readAsString();
  Future<void> run(
    String command,
    List<String> arguments, {
    String? directory,
  }) async {
    stdout.writeln('> $command ${arguments.join(' ')}');
    final process = await Process.start(
      command,
      arguments,
      workingDirectory: directory ?? root,
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) {
      throw ProcessException(
        command,
        arguments,
        'Apple verification failed',
        code,
      );
    }
  }

  try {
    await pubspec.writeAsString(
      original.replaceFirst(
        RegExp(r'^flutter:\n', multiLine: true),
        'flutter:\n  config:\n    enable-swift-package-manager: ${args[0] == 'spm'}\n',
      ),
    );
    await run('flutter', [
      'pub',
      'get',
    ], directory: '$root/shared_preferences_plus/example');
    if (!args.contains('--integration')) {
      await run('flutter', [
        'build',
        args[1],
        '--debug',
        '--no-pub',
        if (args[1] == 'ios') '--simulator',
      ], directory: '$root/shared_preferences_plus/example');
    } else {
      var device = 'macos';
      if (args[1] == 'ios') {
        final result = await Process.run('xcrun', [
          'simctl',
          'list',
          'devices',
          'available',
          '--json',
        ]);
        if (result.exitCode != 0) throw StateError('${result.stderr}');
        final devices =
            (jsonDecode(result.stdout as String)
                    as Map<String, dynamic>)['devices']
                as Map<String, dynamic>;
        final candidates = devices.values
            .expand((group) => group as List)
            .cast<Map<String, dynamic>>()
            .where((item) => (item['name'] as String).startsWith('iPhone'))
            .toList();
        if (candidates.isEmpty) {
          throw StateError(
            'No available iPhone simulator. Install an iOS simulator runtime first.',
          );
        }
        final selected = candidates.firstWhere(
          (item) => item['state'] == 'Booted',
          orElse: () => candidates.first,
        );
        device = selected['udid'] as String;
        final bootedHere = selected['state'] != 'Booted';
        if (bootedHere) await run('xcrun', ['simctl', 'boot', device]);
        try {
          await run('xcrun', ['simctl', 'bootstatus', device, '-b']);
          await run('dart', [
            'run',
            'tool/check.dart',
            '--integration',
            device,
          ]);
        } finally {
          if (bootedHere) await run('xcrun', ['simctl', 'shutdown', device]);
        }
        return;
      }
      await run('dart', ['run', 'tool/check.dart', '--integration', device]);
    }
  } finally {
    await pubspec.writeAsString(original);
    // Refresh metadata to match the restored configuration.
    await run('flutter', ['pub', 'get', '--offline']);
  }
}
