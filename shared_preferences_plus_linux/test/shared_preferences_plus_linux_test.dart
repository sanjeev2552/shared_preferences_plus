import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_linux/shared_preferences_plus_linux.dart';
import 'package:shared_preferences_plus_platform_interface/file_preferences_store.dart';
import 'package:shared_preferences_plus_test_support/platform_contract.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temporary;
  platformContract(
    () async {
      temporary = await Directory.systemTemp.createTemp('preferences-linux-');
      return SharedPreferencesPlusLinux(
        store: FilePreferencesStore(
          directoryProvider: () async => temporary.path,
        ),
      );
    },
    cleanup: () async {
      await temporary.delete(recursive: true);
    },
  );
}
