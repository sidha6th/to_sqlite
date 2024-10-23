import 'dart:async';

import 'package:path/path.dart';

import '../base/generator/sqlite_generator.dart';
import '../base/parser/csv_parser_mixin.dart';
import '../mixins/file_mixin.dart';
import '../mixins/logger_mixin.dart';
import '../services/db/client/database_client.dart';
import '../utils/common/constants.dart';
import '../utils/models/cli_config.dart';

class SqliteGenerator
    with FileMixin, LoggerMixin
    implements IGenerator<CSVParser> {
  const SqliteGenerator._();

  static const IGenerator shared = SqliteGenerator._();

  @override
  Future<void> generate(CSVParser parser, CLIConfig args) async {
    final parsedResult = await parser.parse(
      args.csvPath,
      onStart: () => log('Parsing CSV...'),
      onEnd: () => log('CSV Parsing Completed'),
    );

    exists(join(args.outputPath, 'config.json'), test: (exists) {
      if (exists) return;
      final content = args.copyWith(tableColumns: parsedResult.titles).toJson();
      write(
        filePath: args.outputPath,
        fileName: 'config.json',
        content: content,
      );
    });

    args = args.compareColumn(parsedResult.titles);
    final databasePath = join(args.outputPath, Constants.dbFileName);

    DatabaseClient.shared
      ..open(databasePath)
      ..createTableAndInsert(
        args.tableName,
        columns: args.tableColumns,
        values: parsedResult.values,
        defaultIDColumnName: args.autoIncrementingIDColumnName,
      );
  }
}
