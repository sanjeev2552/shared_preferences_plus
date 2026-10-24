import 'dart:io';

/// Runs the real Foundation storage handler without requiring Flutter UI or a
/// simulator. The small stand-ins only replace generated transport declarations;
/// message-codec tests and native builds separately verify that transport.
Future<void> main() async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('Foundation checks require macOS.');
  }
  final temporary = await Directory.systemTemp.createTemp('preferences-swift-');
  try {
    final handler = await File(
      'shared_preferences_plus_foundation/darwin/shared_preferences_plus_foundation/Sources/shared_preferences_plus_foundation/SharedPreferencesPlusApiHandler.swift',
    ).readAsString();
    final checks = await File('tool/foundation_contract.swift').readAsString();
    final source = File('${temporary.path}/main.swift');
    await source.writeAsString('''
import Foundation
protocol SharedPreferencesPlusApi {}
struct SharedPreferencesPlusPigeonOptions { let name: String }
$handler
$checks
''');
    final executable = '${temporary.path}/foundation-test';
    final compile = await Process.run('swiftc', [
      '-module-cache-path',
      '${temporary.path}/modules',
      source.path,
      '-o',
      executable,
    ]);
    stdout.write(compile.stdout);
    stderr.write(compile.stderr);
    if (compile.exitCode != 0) {
      exitCode = compile.exitCode;
      return;
    }
    final run = await Process.run(executable, []);
    stdout.write(run.stdout);
    stderr.write(run.stderr);
    exitCode = run.exitCode;
  } finally {
    await temporary.delete(recursive: true);
  }
}
