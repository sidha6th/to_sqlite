import 'dart:async';

import 'package:to_sqlite/src/cli_client.dart';

/// This example demonstrates how to the `to_sqlite` library works.
/// You can modify the task to generate a configuration file or database
/// as needed.
/// This code serves as a way to understand and try out the tool
/// directly from the source code.
Future<void> main() async {
  final task = Task.generateDB;

  final arg = [task.command, '-f', task.filePath];
  await CLIClient.shared.execute(arg);
}

enum Task {
  generateDB('generate_db', 'assets/config.json'),
  generateConfig('generate_config', 'assets/test.csv');

  final String command;
  final String filePath;

  const Task(
    this.command,
    this.filePath,
  );
}
