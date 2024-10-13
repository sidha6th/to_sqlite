// For parser
extension StringParserExtension on String {
  bool isValidIndex(int i) => i >= 0 && i < length;
  bool get isDoubleQuote => this == '"';
  bool get isSeperator => this == ',';
  bool get isNewLine => this == '\n' || this == '\r' || this == '\r\n';

  bool get hasNoValue => trim().isEmpty;
  bool get isBackslash => this == r'\';

  Type get parsedType {
    if (int.tryParse(this) != null) {
      return int;
    }

    if (bool.tryParse(this) != null) {
      return bool;
    }

    if (double.tryParse(this) != null) {
      return double;
    }

    return String;
  }
}
