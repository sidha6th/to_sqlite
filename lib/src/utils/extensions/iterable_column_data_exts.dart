import '../common/sql/sql_query_builder.dart';
import '../models/column_data.dart';
import '../models/reference.dart';

extension ColumnsDataExtensions on Iterable<ColumnData> {
  List<String>? get sqlForeignKeysStatements {
    List<String>? foreignKeyStatements;
    sperateForeignKeysAsMap.forEach(
      (key, value) {
        foreignKeyStatements ??= [];
        final thisColumnNames = value.map((e) => e.columnName).join(',');
        final references = value.map((e) => e.referencedColumnName).join(',');
        final statement = (SQL()
          ..foreignKey
          ..add(thisColumnNames)
          ..references
          ..add('$key($references)'));
        foreignKeyStatements?.add(statement.query);
      },
    );

    return foreignKeyStatements;
  }

  // ignore: library_private_types_in_public_api
  Map<String, List<_Connection>> get sperateForeignKeysAsMap {
    final referenceMap = <String, List<_Connection>>{};
    for (var columnData in this) {
      for (var e in columnData.foreignKeys ?? <Reference>[]) {
        final reference = referenceMap[e.referencedTableName];
        if (reference == null || reference.isEmpty) {
          final newReference = referenceMap[e.referencedTableName] = [];
          newReference.add(_Connection(
            columnName: columnData.formattedName,
            referencedColumnName: e.referencedColumn,
          ));
          continue;
        }
        reference.add(_Connection(
          columnName: columnData.formattedName,
          referencedColumnName: e.referencedColumn,
        ));
      }
    }
    return referenceMap;
  }
}

class _Connection {
  final String columnName;
  final String referencedColumnName;
  _Connection({
    required this.columnName,
    required this.referencedColumnName,
  });
}
