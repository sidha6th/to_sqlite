import 'dart:io';

mixin LoggerMixin {
  void log(dynamic value) {
    stdout.writeln(value);
  }

  bool ask(String msg) {
    log(msg);
    log('Confirm: yes|No');
    final input = stdin.readLineSync();
    return input == 'yes' || input == 'y';
  }
}
