import 'base_sql.dart';

class SQLDataTypes extends ISQL {
  SQLDataTypes(super.buffer);

  void get integer => add('INTEGER');

  void get text => add('TEXT');

  void get real => add('REAL');

  void get numeric => add('NUMERIC');

  void get blob => add('BLOB');
}
