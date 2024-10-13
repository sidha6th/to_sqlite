import 'package:args/args.dart';

abstract class ICLIManager {
  ICLIManager() : argParser = ArgParser() {
    init();
  }

  final ArgParser argParser;

  void init();
}
