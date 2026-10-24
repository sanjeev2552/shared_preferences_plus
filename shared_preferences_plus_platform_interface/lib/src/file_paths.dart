import 'dart:io';

/// Supplies the extended-length prefix required by some Windows native APIs.
String nativeFileSystemPath(String path) {
  if (!Platform.isWindows) return path;
  final absolute = File(path).absolute.path.replaceAll('/', '\\');
  if (absolute.startsWith('\\\\?\\')) return absolute;
  if (absolute.startsWith('\\\\')) {
    return '\\\\?\\UNC\\${absolute.substring(2)}';
  }
  return '\\\\?\\$absolute';
}
