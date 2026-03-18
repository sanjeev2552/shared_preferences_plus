import 'dart:convert';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:shared_preferences_plus_platform_interface/types.dart';

class FileUtil {
  FileUtil._();

  static final FileSystem _fileSystem = LocalFileSystem();
  static final PathProviderLinux _pathProviderLinux = PathProviderLinux();

  static Future<File?> _getDbFile(SharedPreferencesPlusOptions options) async {
    final directory = await _pathProviderLinux.getApplicationSupportPath();
    if (directory == null) {
      return null;
    }
    final dbFilePath = path.join(directory, '${options.name}.json');
    return _fileSystem.file(dbFilePath);
  }

  static Future<Map<String, Object?>> readPreferences(SharedPreferencesPlusOptions options) async {
    final file = await _getDbFile(options);
    if (file == null || !file.existsSync()) {
      return {};
    }
    final contents = await file.readAsString();
    if (contents.isEmpty) {
      return {};
    }
    return jsonDecode(contents) as Map<String, Object?>;
  }

  static Future<void> writePreferences(
    SharedPreferencesPlusOptions options,
    Map<String, Object?> preferences,
  ) async {
    final file = await _getDbFile(options);
    if (file == null) {
      throw Exception('Failed to get database file');
    }
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(jsonEncode(preferences));
  }
}
