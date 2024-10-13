import '../int_exts.dart';
import '../string_buffer_exts.dart';

extension StringNameFormattingExtensions on String {
  /// Converts a string to snake_case format.
  ///
  /// This method transforms the input string
  /// by converting all uppercase letters
  /// to lowercase and inserting underscores (`_`) between words that previously
  /// had no separator. Specifically,
  /// an underscore is added before any uppercase
  /// letter that follows a lowercase letter.
  /// Non-alphabetic characters are ignored
  /// and treated as word boundaries.
  ///
  /// Example:
  /// ```
  /// "helloWorld".toSnakeCased -> "hello_world"
  /// "MyNameIsBob".toSnakeCased -> "my_name_is_bob"
  /// "123abcDef".toSnakeCased -> "123abc_def"
  /// ```
  ///
  /// Returns:
  /// - A new `String` in snake_case format, or `null` if the string is empty.
  ///
  /// Notes:
  /// - Each uppercase letter is converted to lowercase, and an underscore (`_`)
  ///   is inserted before it if the preceding character is a lowercase letter.
  /// - Non-alphabetic characters
  /// (e.g., numbers, spaces, punctuation) are preserved
  ///   but do not trigger underscores.
  /// - The string is trimmed before processing.
  String? get toSnakeCased {
    final buffer = StringBuffer();
    for (var i = 0; i < codeUnits.length; i++) {
      if (codeUnits[i].isLowerCaseChar) {
        buffer.write(this[i]);
        continue;
      }
      final wasPreviousCharLowerCased = i > 0 &&
          codeUnits[i - 1].isLowerCaseChar &&
          !codeUnits[i].isUnderscore;
      buffer.customWrite(this[i].trim().toLowerCase(),
          preChar: wasPreviousCharLowerCased ? '_' : '');
    }
    return buffer.isEmpty ? null : buffer.toString();
  }

  /// Converts a string to Upper Camel Case (Pascal Case) format.
  ///
  /// This method capitalizes the first valid alphabetical character and any
  /// subsequent character that follows a non-alphabetical character (such as
  /// spaces, numbers, or symbols). Non-alphabetic characters are ignored but
  /// trigger capitalization for the next valid character.
  ///
  /// Example:
  /// ```
  /// "hello_world".toUpperCamelCased -> "HelloWorld"
  /// "my-name_is bob".toUpperCamelCased -> "MyNameIsBob"
  /// "123 abc_def".toUpperCamelCased -> "AbcDef"
  /// ```
  ///
  /// Returns:
  /// - A new `String` in Upper Camel Case format,
  /// or `null` if the string is empty.
  ///
  /// Notes:
  /// - The first valid alphabetical character is always capitalized.
  /// - Any non-alphabetical character (like numbers or symbols) is ignored but
  ///   causes the next valid alphabetical character to be capitalized.
  /// - Non-alphabetical characters are excluded from the output string.
  ///
  String? get toUpperCamelCased {
    final buffer = StringBuffer();
    var shouldUpperCaseNextChar = true;
    for (var i = 0; i < codeUnits.length; i++) {
      final ascii = codeUnits[i];
      if (!ascii.isAlphabet) {
        shouldUpperCaseNextChar = buffer.isNotEmpty;
        continue;
      }
      if (shouldUpperCaseNextChar) {
        buffer.write(this[i].toUpperCase());
        shouldUpperCaseNextChar = false;
        continue;
      }
      buffer.write(this[i]);
    }
    return buffer.isEmpty ? null : buffer.toString();
  }

  String? get toDartFileNameWithExtension =>
      toSnakeCased == null ? null : '$toSnakeCased.dart';

  String get toFirstLetterLowerCase => this[0].toLowerCase() + substring(1);

  String get toFirstLetterUpperCase => this[0].toUpperCase() + substring(1);
}
