import 'dart:async';

/// Base class for generator
abstract class IGenerator {
  FutureOr<void> generate();
}
