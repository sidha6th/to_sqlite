import 'dart:async';

import 'package:to_sqlite/src/cli_client.dart';

Future<void> main() async {
  const arg = ['generate_db', '-c', 'assets/config.json'];
  await CLIClient.shared.execute(arg);
}
