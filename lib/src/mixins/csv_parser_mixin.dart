import 'dart:async';

import '../base/parser/parser_base.dart';
import '../utils/common/constants.dart';
import '../utils/extensions/string/parser_exts.dart';
import '../utils/extensions/string/string_exts.dart';
import '../utils/extensions/string_buffer_exts.dart';
import '../utils/models/column_data.dart';
import '../utils/types/csv.dart';
import '../utils/types/global.dart';
import 'file_mixin.dart';
import 'type_tracker_mixin.dart';

final class CSVParser
    with TypeTrackerMixin, FileMixin
    implements IParser<ParsedCSVResult> {
  CSVParser(
    this._fallbackToString, {
    required bool enableTypeInference,
  })  : _enableTypeInference = enableTypeInference,
        _valueCache = StringBuffer();

  /// If a value found as Type String when parsing the CSV
  /// and its empty or no value found by default it consider as nullable
  /// If [_fallbackToString] true, will assign an empty string value as default,
  final bool _fallbackToString;

  /// A flag to enable or disable automatic type inference for CSV values.
  ///
  /// If `true`, the app will automatically attempt to detect the most suitable
  /// data type for each value in the CSV file
  /// (such as [int], [double], [String], [bool]).
  /// If `false`, the app will treat all values as strings by default.
  final bool _enableTypeInference;

  /// Cache for separated values by each char.
  final StringBuffer _valueCache;

  /// Stores the metadata for title columns.
  /// Titles include metadata such as type, nullability,
  ///  and column name for each column.
  final _columnsMetaData = <ColumnData>[];

  /// Stores all parsed values as rows, where each row is a list of strings.
  /// Does not contains titles.
  final List<List<String?>> _rows = [];

  List<String?> _tempTitles = <String?>[];

  /// Values of the current working row.
  /// Values are cached here until moving to the next row.
  List<String?> _row = [];

  /// Indicates if the current processed value is surrounded with Quotes.
  bool _wasInsideQuotes = false;

  /// Tracks the index of the current cloumn.
  int _cIndex = 0;

  /// Tracks the index of the current row.
  int _rIndex = 0;

  /// Determines if a value is separable based on the presence of quotes.
  bool _startedWithQuote = false;

  int _quoteCount = 0;

// TODO: Need to improve logic on parsing
// It should also support parsing by reading
// a part of file instead reading entire file.
  @override
  FutureOr<ParsedCSVResult> parse(
    String path, {
    VoidCallback? onStart,
    DelimeterSeperatorCB? onSeperateByDelimeter,
    RowSeperatorCB? onSeperatedByRows,
    VoidCallback? onEnd,
  }) {
    final content = read(path);

    onStart?.call();

    for (var i = 0; i < content.length; i++) {
      final char = content[i];
      final isQuoteChar = char.isDoubleQuote;
      final isLastChar = _row.isNotEmpty && i == content.length - 1;
      if (isQuoteChar) {
        if (!_startedWithQuote) {
          _startedWithQuote = true;
          _wasInsideQuotes = true;
          continue;
        }

        _quoteCount = _trackQuotes(
            i, (i) => i < content.length && content[i].isDoubleQuote);
        i = i + _quoteCount;
        _quoteCount = _quoteCount ~/ 2;
        if (_quoteCount < 1) {
          _startedWithQuote = false;
        }
        if (!isLastChar && _quoteCount < 1) {
          continue;
        }
      }

      final seperateValue = char.isSeperator && !_startedWithQuote;
      final seperateRow = char.isNewLine && !_startedWithQuote;

      _writeChar(
        _quoteCount > 1 ? (Constants.quote * _quoteCount) : char,
        skip: seperateValue || seperateRow,
        whenDone: _resetQuoteCount,
      );

      if (seperateValue || seperateRow || isLastChar) {
        _seperateValue(onSeperateByDelimeter);
      }

      if (seperateRow || isLastChar) {
        _seperateRow(onSeperatedByRows);
      }
    }
    onEnd?.call();
    return (titles: _columnsMetaData, values: _rows);
  }

  /// Will track contigious quotes
  int _trackQuotes(int i, bool Function(int i) isDoubleQuote) {
    var quoteCount = 0;
    while (isDoubleQuote(i)) {
      i++;
      quoteCount++;
    }
    if (quoteCount > 1 && quoteCount.isEven) {
      return quoteCount;
    }
    return 0;
  }

  /// Cache each character.
  /// If [skip] is true, the character will not be cached.
  void _writeChar(String char, {required bool skip, VoidCallback? whenDone}) {
    _valueCache.writeIfValid(char, skip);
    whenDone?.call();
  }

  void _seperateValue([DelimeterSeperatorCB? callback]) {
    final value = _valueCache.toString();
    callback?.call(value, _cIndex);
    if (_rIndex > 0) {
      _trackType();
      _row.add(_columnsMetaData[_cIndex].nullable && value.hasNoValue
          ? null
          : value);
    } else {
      _row.add(value);
    }

    _valueCache.clear();
    _wasInsideQuotes = false;
    _cIndex++;
  }

  void _seperateRow([RowSeperatorCB? callback]) {
    if (_rIndex > 0) {
      _fillRow();
      _rows.add(_row);
    } else {
      _tempTitles = _row;
    }
    callback?.call(_row);
    _cIndex = 0;
    _valueCache.clear();
    _row = [];
    _rIndex++;
  }

  /// Some rows may lack the necessary value length.
  /// Will pad string values to ensure the correct count is maintained.
  void _fillRow() {
    const emptyString = '';
    for (; _cIndex < _tempTitles.length; _cIndex++) {
      _row.add(_columnsMetaData[_cIndex].nullable ? null : emptyString);
      _trackType(true);
    }
  }

  void _trackType([bool empty = false]) {
    final value = empty ? '' : _valueCache.toString();
    final isEmpty = empty || !_wasInsideQuotes && !value.hasValue;
    final type = !_enableTypeInference || _wasInsideQuotes
        ? String
        : (isEmpty ? null : value.parsedType);

    trackType(
      _columnsMetaData,
      _tempTitles,
      colIndex: _cIndex,
      isEmpty: isEmpty,
      type: type,
      fallbackToString: _fallbackToString,
    );
  }

  void _resetQuoteCount() => _quoteCount = 0;
}
