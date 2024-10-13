import 'dart:convert';

import 'package:path/path.dart';

import '../common/constants.dart';
import '../extensions/string/name_formatting_extension.dart';
import 'column_data.dart';

class CLIConfig {
  /// The file path to the CSV file that will be parsed.
  ///
  /// This is a required parameter that specifies the location of the CSV file
  /// on the filesystem.
  final String csvPath;

  /// The directory or file path where the parsed output will be saved.
  ///
  /// This could be a directory for multiple outputs
  /// or a file for single output,
  /// depending on how the program processes the parsed data.
  final String outputPath;

  /// The name of the database table that will be created
  /// or updated with the parsed CSV data.
  ///
  /// This name is used when generating SQL or other database schema outputs.
  final String tableName;

  /// A list of column metadata representing the schema of the table.
  ///
  /// This list contains information such as column names, data types, and other
  /// column-related details.
  /// It is used to ensure the correct structure when inserting
  /// the parsed CSV data into the table.
  final List<ColumnData> tableColumns;

  /// A flag indicating how empty values in the CSV should be handled during
  /// type inference.
  ///
  /// If `true`, any column that contains
  /// empty values will be treated as nullable,
  /// allowing `null` values to exist in that column.
  /// If `false`, the entire column
  /// type will be converted to `String`
  /// and any empty values will be stored as empty
  /// strings (`""`).
  /// This is useful for handling optional data and ensuring flexibility
  /// in schema design,
  /// especially when dealing with incomplete or sparse datasets.
  final bool fallbackToStringOnNullableValue;

  /// A flag to enable or disable automatic type inference for CSV values.
  ///
  /// If `true`, the app will automatically attempt to detect the most suitable
  /// data type for each value in the CSV file
  /// (such as [int], [double], [String], [bool]).
  /// If `false`, the app will treat all values as strings by default.
  final bool enableTypeInference;

  const CLIConfig({
    required this.fallbackToStringOnNullableValue,
    required this.csvPath,
    required this.outputPath,
    required this.tableName,
    required this.tableColumns,
    required this.enableTypeInference,
  });

  factory CLIConfig.fromMap(
    Map<String, dynamic> map, {
    required String configPath,
  }) {
    final csvPath = map['csv'] as String;
    final fileName = basenameWithoutExtension(csvPath);
    final out = split(configPath);
    return CLIConfig(
      csvPath: csvPath,
      outputPath: (map['output_path'] as String?) ??
          joinAll(out.sublist(0, out.length - 1)),
      tableName: ((map['table_name'] as String?) ?? fileName).toSnakeCased ??
          Constants.tableNameLowerCased,
      fallbackToStringOnNullableValue: (bool.tryParse(
              map['fallback_to_string_on_nullable_value'].toString())) ??
          false,
      tableColumns: (map['table_columns'] as List? ?? [])
          .map(
            (e) => ColumnData.fromMap(e as Map<String, String>),
          )
          .toList(),
      enableTypeInference:
          bool.tryParse(map['enable_type_inference'].toString()) ?? true,
    );
  }

  factory CLIConfig.fromCSV(String csvPath) {
    final fileName = basenameWithoutExtension(csvPath);
    final out = split(csvPath);
    return CLIConfig(
      csvPath: csvPath,
      outputPath: joinAll(out.sublist(0, out.length - 1)),
      tableName: fileName.toSnakeCased ?? Constants.tableNameLowerCased,
      fallbackToStringOnNullableValue: false,
      enableTypeInference: true,
      tableColumns: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'csv': csvPath,
      'output_path': outputPath,
      'table_name': tableName,
      'fallback_to_string_on_nullable_value': fallbackToStringOnNullableValue,
      'enable_type_inference': enableTypeInference,
      'table_columns': tableColumns.map((column) => column.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  CLIConfig copyWith({
    String? csvPath,
    String? outputPath,
    String? tableName,
    List<ColumnData>? tableColumns,
    bool? fallbackToStringOnNullableValue,
    bool? enableTypeInference,
  }) {
    return CLIConfig(
      csvPath: csvPath ?? this.csvPath,
      outputPath: outputPath ?? this.outputPath,
      tableName: tableName ?? this.tableName,
      tableColumns: tableColumns ?? this.tableColumns,
      fallbackToStringOnNullableValue: fallbackToStringOnNullableValue ??
          this.fallbackToStringOnNullableValue,
      enableTypeInference: enableTypeInference ?? this.enableTypeInference,
    );
  }

  CLIConfig compareColumn(List<ColumnData> parsedColumnData) {
    if (tableColumns.isEmpty) {
      return copyWith(tableColumns: parsedColumnData);
    }

    if (tableColumns.length > parsedColumnData.length) {
      final dif = tableColumns.length - parsedColumnData.length;
      throw Exception(
        '''$dif extra column found in the config file, 
        Please verify and try again''',
      );
    }

    return this;
  }
}
