import 'sql_operators.dart';

final class SQL extends SQLOperators {
  SQL() : super(StringBuffer());

  void get create => add('CREATE');

  void get table => add('TABLE');

  void get delete => add('DELETE');

  void get select => add('SELECT');

  void get from => add('FROM');

  void get insetInTo => add('INSERT INTO');

  void get values => add('VALUES');

  void get where => add('WHERE');

  void get and => add('AND');

  void get primaryKey => add('PRIMARY KEY');

  void get foreignKey => add('FOREIGN KEY');

  void get references => add('REFERENCES');

  void get autoIncrement => add('AUTOINCREMENT');

  void valuesPlaceHolder(int length) {
    add('(${List.filled(length, '?').join(',')})');
  }
}
