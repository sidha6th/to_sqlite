class Reference {
  const Reference({
    required this.referencedTableName,
    required this.referencedColumn,
  });

  final String referencedTableName;
  final String referencedColumn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'table': referencedTableName,
      'column': referencedColumn,
    };
  }

  factory Reference.fromMap(Map<String, dynamic> map) {
    return Reference(
      referencedTableName: map['table'] as String,
      referencedColumn: map['column'] as String,
    );
  }

  @override
  bool operator ==(covariant Reference other) {
    if (identical(this, other)) return true;

    return other.referencedTableName == referencedTableName &&
        other.referencedColumn == referencedColumn;
  }

  @override
  int get hashCode => referencedTableName.hashCode ^ referencedColumn.hashCode;
}
