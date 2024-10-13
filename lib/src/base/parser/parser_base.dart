import 'dart:async';

/// Base class for parser
/// Type [R] Result
abstract class IParser<R> {
  FutureOr<R?> parse(String content);
}
