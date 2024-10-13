enum CLIOptions {
  file(
    abbr: 'f',
    help: 'Path to the CSV file to be converted into SQLite database.',
  );

  const CLIOptions({
    required this.abbr,
    required this.help,
  });

  final String abbr;
  final String help;
}
