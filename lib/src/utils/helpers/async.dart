import 'dart:async';

Future<T?> asyncGaurd<T>(
  Future<T> Function() task, {
  FutureOr<T?> Function(Object e)? onError,
  FutureOr<void> Function()? onFinally,
}) async {
  try {
    return task();
  } catch (e) {
    return onError?.call(e);
  } finally {
    onFinally?.call();
  }
}

T? gaurd<T>(
  T Function() task, {
  void Function(Object e)? onError,
  void Function()? onFinally,
}) {
  try {
    return task();
  } catch (e) {
    onError?.call(e);
    return null;
  } finally {
    onFinally?.call();
  }
}
