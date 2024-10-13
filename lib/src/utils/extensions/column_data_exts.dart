import '../models/column_data.dart';
import 'string/string_exts.dart';

extension ColumnDataExts on ColumnData {
  String valueConstructor(int i) {
    final item =
        'values[i][$i].typCast(${type ?? String},$nullable, "$formattedName:[$i]")';
    return "Value${nullable ? ".absentIfNull" : ''}($item)";
  }

  String get schema {
    return '$sqlColumnName $sqlType $sqlPrimaryKey $sqlNullablity $sqlDefault $sqlUniqability $sqlCheck'
        .trim();
  }

  String get sqlColumnName => formattedName;

  String get sqlType {
    if (type == String) {
      return 'TEXT';
    }
    if (type == double) {
      return 'REAL';
    }
    if (type == int || type == bool) {
      return 'INTEGER';
    }
    return 'TEXT';
  }

  String get sqlNullablity => nullable ? '' : 'NOT NULL';

  String get sqlPrimaryKey => primaryKey ? 'PRIMARY KEY' : '';

  String get sqlUniqability => unique ? 'UNIQUE' : '';

  String get sqlDefault =>
      defaultValue.hasValue ? ('DEFAULT $defaultValue') : '';

  String get sqlCheck => check.hasValue ? 'CHECK $check' : '';

  String get toPropertyFormat {
    return (StringBuffer()
          ..write('final ')
          ..write('$type ')
          ..write(nullable ? '? ' : '')
          ..write('$name;'))
        .toString();
  }
}
