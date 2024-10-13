import 'dart:async';

import '../models/column_data.dart';

typedef ParsedCSVResult = ({
  List<ColumnData> titles,
  List<List<String?>> values
});

typedef DelimeterSeperatorCB = FutureOr<void> Function(String value, int index);

typedef RowSeperatorCB = FutureOr<void> Function(List<String?> row);
