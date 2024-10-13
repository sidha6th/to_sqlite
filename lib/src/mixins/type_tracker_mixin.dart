import '../utils/extensions/string/string_exts.dart';
import '../utils/extensions/type_extension.dart';
import '../utils/models/column_data.dart';

mixin TypeTrackerMixin {
  void trackType(
    List<ColumnData> columns,
    List<String?> titles, {
    required int colIndex,
    required bool isEmpty,
    required Type? type,
    required bool fallbackToString,
  }) {
    if (titles.isEmpty) return;

    final title = titles[colIndex];
    if (!title.hasValue) {
      throw Exception('Title should not be empty');
    }
    final hasDataAtThisIndex = colIndex < columns.length;

    if (!hasDataAtThisIndex) {
      columns.add(_whenDataAlreadyPresent(
        fallbackToString: fallbackToString,
        isEmpty: isEmpty,
        title: title!,
        type: type,
      ));
      return;
    }

    final colData = columns[colIndex];
    final prevType = colData.type;
    final finalizedType = prevType.compareAndFinalize(type);
    columns[colIndex] = colData.copyWith(
      type: finalizedType,
      nullable: finalizedType.nullable(
        fallbackToString,
        colData.nullable || isEmpty,
      ),
    );
  }

  ColumnData _whenDataAlreadyPresent({
    required String title,
    required Type? type,
    required bool fallbackToString,
    required bool isEmpty,
  }) {
    final stringNullable = type == String && !fallbackToString && isEmpty;
    final notStringButEmpty = type != String && isEmpty;
    return ColumnData(
      name: title,
      type: type,
      nullable: stringNullable || notStringButEmpty,
    );
  }
}
