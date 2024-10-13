import 'features/config_generator.dart';
import 'features/model_class_generator.dart';
import 'features/sqlite_generator.dart';
import 'mixins/config_parser_mixin.dart';
import 'mixins/file_mixin.dart';
import 'mixins/logger_mixin.dart';
import 'services/cli_manager/commands_manager.dart';
import 'utils/extensions/arg_result_exts.dart';

class CLIClient extends CommandsManager
    with FileMixin, ConfigParserMixin, LoggerMixin {
  CLIClient._();

  static final shared = CLIClient._();

  Future<void> execute(List<String> arguments) async {
    final result = argParser.parse(arguments);
    await result.when(
      parseConfig,
      generateDB: SqliteGenerator.shared.generate,
      generateConfig: ConfigGenerator.shared.generate,
      generateModelClass: ModelClassGenerator.shared.generate,
      completed: _completed,
      failed: _failed,
    );
  }

  void _failed(Object e) {
    log('Failed');
    log(e);
  }

  void _completed() {
    log('Completed');
  }
}
