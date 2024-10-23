import 'dart:async';

import '../base/generator/sqlite_generator.dart';
import '../base/parser/csv_parser_mixin.dart';
import '../mixins/file_mixin.dart';
import '../mixins/logger_mixin.dart';
import '../utils/models/cli_config.dart';

class ConfigGenerator
    with FileMixin, LoggerMixin
    implements IGenerator<CSVParser> {
  const ConfigGenerator();

  static const IGenerator shared = ConfigGenerator();

  @override
  FutureOr<void> generate(CSVParser parser, CLIConfig args) async {
    final parsedResult = await parser.parse(
      args.csvPath,
      onStart: () => log('CSV parsing ...'),
      onEnd: () => log('CSV parsed'),
    );

    final content = args.copyWith(tableColumns: parsedResult.titles).toJson();

    return write(
      filePath: args.outputPath,
      fileName: 'config.json',
      content: content,
    );
  }
}
