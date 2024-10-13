import 'dart:async';

import 'package:to_sqlite/src/cli_client.dart';

Future<void> main(List<String> args) async {
  await CLIClient.shared.execute(args);
}
