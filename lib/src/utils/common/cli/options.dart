enum CLIOptions {
  filePath(
    abbr: 'f',
    help:
        'Path to the CSV or Config.json file to convert into SQLite database.',
  );

  final String abbr;

  final String help;
  const CLIOptions({
    required this.abbr,
    required this.help,
  });
}
