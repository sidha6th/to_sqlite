import '../utils/common/sql/sql_query_builder.dart';
import '../utils/extensions/column_data_exts.dart';
import '../utils/extensions/iterable_column_data_exts.dart';
import '../utils/models/column_data.dart';

mixin SqlSchemaMixin {
  String generateColumnsSchema(
    List<ColumnData> columns,
    String? defaultIDColumnName,
  ) {
    final schema = columns.map((e) {
      return e.schema;
    }).join(',');

    final schemaWithDefaultID = defaultIDColumnName == null
        ? schema
        : '${_defaultID(defaultIDColumnName)},$schema';

    final foreignKeys = columns.sqlForeignKeysStatements?.join(',');
    if (foreignKeys == null) {
      return schemaWithDefaultID;
    }
    return '$schemaWithDefaultID,$foreignKeys';
  }

  String _defaultID(String name) {
    return (SQL()
          ..add(name)
          ..integer
          ..primaryKey
          ..autoIncrement)
        .query;
  }

  void insertionStatement({
    required List<ColumnData> columns,
    required List<List<String?>> values,
    required String tableName,
    required void Function(String statement, List<Object?> values)
        onEachSetValue,
  }) {
    final joinedColumnNames = columns.map((e) => e.formattedName).join(',');
    final statement = (SQL()
          ..insetInTo
          ..add(tableName)
          ..add('($joinedColumnNames)')
          ..values
          ..valuesPlaceHolder(columns.length))
        .query;

    /// TODO: need to change this to batch insert
    /// insted of exicuting on each iteration.
    for (var i = 0; i < values.length; i++) {
      final dif = columns.length - values[i].length;
      final currentRow = [...values[i], ...List.filled(dif, null)];
      onEachSetValue(statement, currentRow);
    }
  }

  SQL tableCreationQuery(String tableName, String columnsSchema) {
    return (SQL()
      ..create
      ..table
      ..add(tableName)
      ..add('($columnsSchema)'));
  }

  SQL tableExitsStatement(String tableName) {
    return (SQL()
      ..select
      ..add('name')
      ..from
      ..add('sqlite_master')
      ..where
      ..equalTo('type', 'table')
      ..and
      ..equalTo('name', tableName));
  }
}
