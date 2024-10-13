import 'dart:async';

import 'package:args/args.dart';

import '../../mixins/csv_parser_mixin.dart';
import '../common/cli/commands.dart';
import '../common/cli/options.dart';
import '../helpers/async.dart';
import '../models/cli_config.dart';
import '../types/global.dart';

extension ArgResultsExtensions on ArgResults {
  Future<void> when(
    CLIConfig Function(String filePath) configCB, {
    required FutureOr<void> Function(CSVParser, CLIConfig) generateDB,
    required FutureOr<void> Function(CSVParser, CLIConfig) generateConfig,
    required FutureOr<void> Function(CSVParser, CLIConfig) generateModelClass,
    VoidCallback? completed,
    void Function(Object e)? failed,
  }) async {
    await asyncGaurd(
      () async {
        if (command?.name == null) {
          failed?.call('command couldn\'t be empty or null');
          return;
        }
        final config = configCB(_filePath);
        final csvParser = CSVParser(
          config.fallbackToStringOnNullableValue,
          enableTypeInference: config.enableTypeInference,
        );

        switch (command!.name) {
          case CLICommands.generationDB:
            await generateDB(csvParser, config);
          case CLICommands.generateConfig:
            await generateConfig(csvParser, config);
          case CLICommands.generateModelClass:
            await generateModelClass(csvParser, config);
        }
        completed?.call();
      },
      onError: failed,
    );
  }

  String get _filePath => this[CLIOptions.file.name] as String;
}
