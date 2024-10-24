import 'dart:async';

import '../../utils/models/cli_config.dart';
import '../parser/parser_base.dart';

abstract class IGenerator<TParser extends IParser> {
  const IGenerator();

  FutureOr<void> generate(
    TParser parser,
    CLIConfig args,
  );
}
