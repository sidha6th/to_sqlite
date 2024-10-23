import '../../../utils/models/column_data.dart';

abstract class IDatabaseClient {
  void open(String path);

  void createTableAndInsert(
    String tableName, {
    required List<ColumnData> columns,
    required List<List<String>> values,
    String? defaultIDColumnName,
  });
}
