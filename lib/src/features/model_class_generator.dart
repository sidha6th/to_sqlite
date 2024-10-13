import 'dart:async';

import 'package:path/path.dart';

import '../base/generator/sqlite_generator.dart';
import '../mixins/csv_parser_mixin.dart';
import '../mixins/logger_mixin.dart';
import '../template/generator/model_class_generator.dart';
import '../utils/common/constants.dart';
import '../utils/extensions/string/name_formatting_extension.dart';
import '../utils/models/cli_config.dart';
import '../utils/models/template_generator_args/model_class.dart';

class ModelClassGenerator with LoggerMixin implements IGenerator<CSVParser> {
  const ModelClassGenerator();

  static const shared = ModelClassGenerator();

  @override
  FutureOr<void> generate(CSVParser parser, CLIConfig args) async {
    final parsedResult = await parser.parse(
      args.csvPath,
      onStart: () => log('CSV parsing ...'),
      onEnd: () => log('CSV parsed'),
    );

    await ModelClassTemplateGenerator.shared.generate(
      ModelClassTemplateArg(
        fields: parsedResult.titles,
        className:
            split(withoutExtension(args.csvPath)).last.toUpperCamelCased ??
                Constants.defModel,
      ),
    );
  }
}
