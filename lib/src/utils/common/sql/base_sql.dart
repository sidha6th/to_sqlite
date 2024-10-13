import '../../extensions/string_buffer_exts.dart';

abstract class ISQL {
  ISQL(this._buffer);
  final StringBuffer _buffer;

  void add(String statement) => _write(statement);

  void _write(String statement) {
    return _buffer.customWrite(statement, preChar: _buffer.isEmpty ? '' : ' ');
  }

  String get query {
    return _buffer.toString();
  }
}
