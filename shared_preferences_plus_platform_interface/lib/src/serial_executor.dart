/// Runs asynchronous operations in call order without poisoning the queue when
/// an operation fails. Separate executors can progress independently.
class SerialExecutor {
  Future<void> _tail = Future<void>.value();

  /// Schedules [operation] after all previously scheduled operations settle.
  Future<T> run<T>(Future<T> Function() operation) {
    final result = _tail.then((_) => operation());
    _tail = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return result;
  }
}
