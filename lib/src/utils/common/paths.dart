import 'package:path/path.dart';

final class Paths {
  const Paths._();
  static const shared = Paths._();

  String get baseDir => joinAll(['lib', 'src', 'utils', 'db']);
  String get tables => joinAll([baseDir, 'tables']);
  String get models => joinAll([baseDir, 'models']);
  String get dbClient => joinAll([baseDir, 'client']);
  String get cache => joinAll([baseDir, 'cache']);
}
