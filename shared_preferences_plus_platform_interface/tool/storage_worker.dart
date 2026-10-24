import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_platform_interface/src/file_lock.dart';
import 'dart:io';
import 'dart:async';

/// Separate-process writer used by the storage regression suite.
Future<void> main(List<String> args) async {
  if (args[1] == 'hold') {
    final lock = await PreferencesFileLock.acquire(
      args[0],
      const Duration(seconds: 2),
    );
    stdout.writeln('locked');
    await stdout.flush();
    await Completer<void>().future;
    lock.release();
    return;
  }
  final store = FilePreferencesStore(directoryProvider: () async => args[0]);
  for (var i = 0; i < 15; i++) {
    await store.update('concurrent', (values) {
      values['${args[1]}-$i'] = i;
    });
  }
}
