part of 'generator/model_class_generator.dart';

class _ModelClassTemplate {
  const _ModelClassTemplate._();
  static final shared = const _ModelClassTemplate._();

  StringBuffer generate(
    List<ColumnData> fields, {
    required String className,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('// ignore_for_file: non_constant_identifier_names');
    buffer.writeln('class $className{');
    _generateConstructor(fields, buffer, className);
    _generateMembers(fields, buffer);
    buffer.write('}');

    return buffer;
  }

  void _generateConstructor(
      List<ColumnData> titles, StringBuffer buffer, String className) {
    buffer.writeln('  const $className({');
    for (var element in titles) {
      buffer.writeln('    required this.${element.name},');
    }
    buffer.writeln('  });\n');
  }

  void _generateMembers(List<ColumnData> titles, StringBuffer buffer) {
    for (var element in titles) {
      buffer.writeln('  ${element.toPropertyFormat}');
    }
  }
}
