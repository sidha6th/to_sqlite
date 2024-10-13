extension StringExts on String {
  bool get hasValue => trim().isNotEmpty;

  Object? parseTo(Type? type) {
    if (type == int) {
      return int.tryParse(this);
    }
    if (type == double) {
      return double.tryParse(this);
    }

    if (type == bool) {
      return (bool.tryParse(this) ?? false) ? 1 : 0;
    }

    return this;
  }

  bool get isCSV => endsWith('.csv');

  bool get isJson => endsWith('.json');
}

extension NullableStringExts on String? {
  bool get hasValue => this != null && (this!.trim().isNotEmpty);
}
