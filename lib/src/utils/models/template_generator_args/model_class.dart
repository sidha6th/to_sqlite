import '../column_data.dart';

final class ModelClassTemplateArg {
  final List<ColumnData> fields;
  final String className;

  const ModelClassTemplateArg({
    required this.fields,
    required this.className,
  });
}
