import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Locks an OS handle rather than a Dart advisory lock. flock locks distinct
/// file descriptions, so separate isolates in the same process also serialize.
/// Windows uses a handle opened without sharing. The OS releases either lock
/// when the process exits; the persistent lock file must never be deleted.
class PreferencesFileLock {
  PreferencesFileLock._(this._release);
  final void Function() _release;

  /// Acquires a lock with bounded, nonblocking retries.
  static Future<PreferencesFileLock> acquire(
    String path,
    Duration timeout,
  ) async {
    final watch = Stopwatch()..start();
    if (Platform.isWindows) {
      final library = DynamicLibrary.open('kernel32.dll');
      final open = library
          .lookupFunction<
            IntPtr Function(
              Pointer<Utf16>,
              Uint32,
              Uint32,
              Pointer<Void>,
              Uint32,
              Uint32,
              IntPtr,
            ),
            int Function(Pointer<Utf16>, int, int, Pointer<Void>, int, int, int)
          >('CreateFileW');
      final close = library
          .lookupFunction<Int32 Function(IntPtr), int Function(int)>(
            'CloseHandle',
          );
      final lastError = library
          .lookupFunction<Uint32 Function(), int Function()>('GetLastError');
      // dart:io normalizes long Windows paths internally; direct Win32 calls
      // need the extended-length prefix explicitly, including for UNC paths.
      final absolutePath = File(path).absolute.path;
      final extendedPath = absolutePath.startsWith('\\\\?\\')
          ? absolutePath
          : absolutePath.startsWith('\\\\')
          ? '\\\\?\\UNC\\${absolutePath.substring(2)}'
          : '\\\\?\\$absolutePath';
      final nativePath = extendedPath.toNativeUtf16();
      try {
        while (true) {
          final handle = open(nativePath, 0xC0000000, 0, nullptr, 4, 0x80, 0);
          if (handle != -1) {
            return PreferencesFileLock._(() {
              close(handle);
            });
          }
          final error = lastError();
          if (error != 32 && error != 33) {
            throw FileSystemException(
              'Unable to open preferences lock',
              path,
              OSError('CreateFileW', error),
            );
          }
          await _retry(watch, timeout, path);
        }
      } finally {
        calloc.free(nativePath);
      }
    }
    if (!Platform.isLinux && !Platform.isMacOS) {
      throw UnsupportedError(
        'File preferences require Linux, macOS or Windows.',
      );
    }
    final library = DynamicLibrary.process();
    final open = library
        .lookupFunction<
          Pointer<Void> Function(Pointer<Utf8>, Pointer<Utf8>),
          Pointer<Void> Function(Pointer<Utf8>, Pointer<Utf8>)
        >('fopen');
    final descriptor = library
        .lookupFunction<
          Int Function(Pointer<Void>),
          int Function(Pointer<Void>)
        >('fileno');
    final flock = library
        .lookupFunction<Int Function(Int, Int), int Function(int, int)>(
          'flock',
        );
    final close = library
        .lookupFunction<
          Int Function(Pointer<Void>),
          int Function(Pointer<Void>)
        >('fclose');
    final errno = library
        .lookupFunction<Pointer<Int> Function(), Pointer<Int> Function()>(
          Platform.isMacOS ? '__error' : '__errno_location',
        );
    final nativePath = path.toNativeUtf8();
    final mode = 'a+'.toNativeUtf8();
    final handle = open(nativePath, mode);
    calloc.free(nativePath);
    calloc.free(mode);
    if (handle == nullptr) {
      throw FileSystemException(
        'Unable to open preferences lock',
        path,
        OSError('fopen', errno().value),
      );
    }
    try {
      while (flock(descriptor(handle), 2 | 4) != 0) {
        final error = errno().value;
        if (error != (Platform.isMacOS ? 35 : 11) && error != 4) {
          throw FileSystemException(
            'Unable to lock preferences',
            path,
            OSError('flock', error),
          );
        }
        await _retry(watch, timeout, path);
      }
    } catch (_) {
      close(handle);
      rethrow;
    }
    return PreferencesFileLock._(() {
      close(handle);
    });
  }

  static Future<void> _retry(
    Stopwatch watch,
    Duration timeout,
    String path,
  ) async {
    if (watch.elapsed >= timeout) {
      throw FileSystemException('Timed out acquiring preferences lock', path);
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  /// Releases the OS handle. Must be called exactly once.
  void release() => _release();
}
