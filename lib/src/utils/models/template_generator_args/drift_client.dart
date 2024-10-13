import '../column_data.dart';

class DBClientTemplateArg {
  final Iterable<String> fileNames;
  final Iterable<String> tableNames;
  final List<ColumnData> members;
  final String currentTableName;

  DBClientTemplateArg({
    required this.fileNames,
    required this.tableNames,
    required this.members,
    required this.currentTableName,
  });
}
