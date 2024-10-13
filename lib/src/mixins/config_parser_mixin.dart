import 'dart:convert';

import '../utils/extensions/string/string_exts.dart';
import '../utils/models/cli_config.dart';
import 'file_mixin.dart';

mixin ConfigParserMixin on FileMixin {
  CLIConfig parseConfig(String filePath) {
    if (filePath.isJson) {
      final configData = read(filePath);
      final config = jsonDecode(configData) as Map<String, dynamic>?;
      if (config == null) {
        throw Exception('Something went wrong while parsing the config file');
      }
      return CLIConfig.fromMap(config, configPath: filePath);
    }
    return CLIConfig.fromCSV(filePath);
  }
}
