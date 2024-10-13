import '../utils/common/sql/sql_query_builder.dart';
import '../utils/common/constants.dart';
import '../utils/extensions/column_data_exts.dart';
import '../utils/extensions/iterable_column_data_exts.dart';
import '../utils/models/column_data.dart';

mixin SqlSchemaMixin {
  String generateColumnsSchema(List<ColumnData> columns) {
    var hasAnyPrimaryKeys = false;
    final schema = columns.map((e) {
      hasAnyPrimaryKeys = e.primaryKey;
      return e.schema;
    }).join(',');

    final finalizedSchema =
        !hasAnyPrimaryKeys ? '${defaultID()}, $schema' : schema;
    final foreignKeys = columns.sqlForeignKeysStatements?.join(',');
    if (foreignKeys == null) {
      return finalizedSchema;
    }
    return '$finalizedSchema,$foreignKeys';
  }

  String defaultID([String? name]) {
    return (SQL()
          ..add(name ?? Constants.defTableIDName)
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
      onEachSetValue(statement, values[i]);
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
