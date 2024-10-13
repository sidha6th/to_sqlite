import '../column_data.dart';

final class TableTemplateArg {
  const TableTemplateArg({
    required this.fields,
    required this.className,
    required this.primaryKey,
  });

  final List<ColumnData> fields;
  final String className;
  final List<String> primaryKey;
}
