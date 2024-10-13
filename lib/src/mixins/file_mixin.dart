import 'dart:io';

import 'package:path/path.dart' show join;

mixin FileMixin {
  void write({
    required String filePath,
    required String fileName,
    required String content,
    FileMode mode = FileMode.write,
  }) {
    exists(filePath, test: (exists) {
      if (!exists) Directory(filePath).createSync();
    });

    final file = File(join(filePath, fileName));
    if (file.existsSync()) {
      file.deleteSync();
    }

    file.writeAsStringSync(content.toString(), mode: mode);
  }

  String read(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('$path dosen\'t exist');
    }
    return file.readAsStringSync();
  }

  void delete(String path) {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  void exists(String filePath, {void Function(bool exists)? test}) {
    final exists = File(filePath).existsSync();
    return test?.call(exists);
  }
}
