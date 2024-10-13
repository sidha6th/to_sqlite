import 'sql_data_types.dart';

class SQLOperators extends SQLDataTypes {
  SQLOperators(super.buffer);

  void equalTo(String a, String b) => add('$a = \'$b\'');
}
