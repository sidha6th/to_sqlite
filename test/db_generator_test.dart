import 'dart:io';

import 'package:to_sqlite/src/cli_client.dart';

void main() async {
  const arg = ['generate_config', '-f', 'assets/test.csv'];
  await CLIClient.shared.execute(arg);
  exit(0);
}
