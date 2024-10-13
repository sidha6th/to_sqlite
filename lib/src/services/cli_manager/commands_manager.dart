import '../../utils/common/cli/commands.dart';
import '../../utils/common/cli/options.dart';
import 'cli_manager_base.dart';

class CommandsManager extends ICLIManager {
  CommandsManager();

  @override
  void init() {
    _addCommands();
    _addOptions();
  }

  void _addCommands() {
    argParser.addCommand(CLICommands.generationDB);
    argParser.addCommand(CLICommands.generateConfig);
    argParser.addCommand(CLICommands.generateModelClass);
  }

  void _addOptions() {
    for (var option in CLIOptions.values) {
      argParser.addOption(
        option.name,
        abbr: option.abbr,
        help: option.help,
        mandatory: true,
      );
    }
  }
}
