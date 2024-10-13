extension DartTypeToDriftType on Type? {
  Type? compareAndFinalize(Type? other) {
    if (this == null || other == null || this == other) {
      return other ?? this;
    }
    if (isString || other.isString) {
      return String;
    }
    if (isDouble || other.isDouble) {
      return double;
    }
    return String;
  }

  bool nullable(
    bool fallbackToString,
    bool nullableOrEmpty,
  ) {
    return (this == String && !fallbackToString && nullableOrEmpty) ||
        (this != String && nullableOrEmpty);
  }

  dynamic parse<T>(String value) {
    if (this == double) {
      return double.tryParse(value);
    }
    if (this == int) {
      return int.tryParse(value);
    }
    if (this == bool) {
      return bool.tryParse(value);
    }
    return value;
  }

  bool get isInt => this == int;
  bool get isDouble => this == double;
  bool get isString => this == String;
  bool get isBool => this == bool;
}
