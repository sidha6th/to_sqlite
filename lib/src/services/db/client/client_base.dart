import '../../../utils/models/column_data.dart';

abstract class IDatabaseClient {
  void open(String path);

  void createTableAndInsert(
    String tableName,
    List<ColumnData> columns,
    List<List<String>> values,
  );
}
