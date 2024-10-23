import 'package:sqlite3/sqlite3.dart';

import '../../../mixins/file_mixin.dart';
import '../../../mixins/logger_mixin.dart';
import '../../../mixins/sql_schema_mixin.dart';
import '../../../utils/models/column_data.dart';
import 'client_base.dart';

class DatabaseClient
    with SqlSchemaMixin, FileMixin, LoggerMixin
    implements IDatabaseClient {
  DatabaseClient._();

  static final DatabaseClient shared = DatabaseClient._();

  Database? _database;

  bool get isOpen => _database != null;

  @override
  void open(String fullPath) {
    _database = sqlite3.open(fullPath);
  }

  @override
  void createTableAndInsert(
    String tableName, {
    required List<ColumnData> columns,
    required List<List<String?>> values,
    String? defaultIDColumnName,
  }) {
    if (!isOpen) {
      throw Exception('Should open the database before execute');
    }
    log('Table - $tableName creation started...');
    final tableCreationStatement = tableCreationQuery(
      tableName,
      generateColumnsSchema(columns, defaultIDColumnName),
    );

    _database?.execute(tableCreationStatement.query);
    log('Table - $tableName created');

    log('Inserting values to the table - $tableName ');
    insertionStatement(
        columns: columns,
        tableName: tableName,
        values: values,
        onEachSetValue: (statement, values) {
          _database?.execute(statement, values);
        });
  }
}
