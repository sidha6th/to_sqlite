import 'dart:convert';

import 'package:collection/collection.dart';

import '../extensions/string/name_formatting_extension.dart';
import 'reference.dart';

class ColumnData {
  final String name;

  final Type? type;
  final bool nullable;
  final String? defaultValue;
  final bool primaryKey;
  final bool unique;
  final String? check;
  final List<Reference>? foreignKeys;
  const ColumnData({
    required this.name,
    required this.type,
    this.nullable = false,
    this.defaultValue,
    this.primaryKey = false,
    this.unique = false,
    this.check,
    this.foreignKeys = const [],
  });

  factory ColumnData.fromMap(Map<String, dynamic> map) {
    return ColumnData(
      name: map['name'] as String,
      type: map['type'] as Type?,
      nullable: map['nullable'] as bool? ?? false,
      defaultValue: map['default'] as String?,
      primaryKey: map['primaryKey'] as bool? ?? false,
      foreignKeys: (map['foreign_keys'] as List? ?? [])
          .map(
            (e) => Reference.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
      // TODO: need to test and rollout
      // unique: map['unique'] as bool? ?? false,
      // check: map['check'] as String?,
    );
  }

  Type get finalizedType => type ?? String;
  String get formattedName {
    final result = name.toSnakeCased;
    if (result == null) {
      throw Exception('Unsupported Column name - $name');
    }
    return result;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        nullable.hashCode ^
        defaultValue.hashCode ^
        primaryKey.hashCode ^
        unique.hashCode ^
        check.hashCode ^
        foreignKeys.hashCode;
  }

  @override
  bool operator ==(covariant ColumnData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.type == type &&
        other.nullable == nullable &&
        other.defaultValue == defaultValue &&
        other.primaryKey == primaryKey &&
        other.unique == unique &&
        other.check == check &&
        listEquals(other.foreignKeys, foreignKeys);
  }

  ColumnData copyWith({
    String? name,
    Type? type,
    bool? nullable,
    String? defaultValue,
    bool? primaryKey,
  }) {
    return ColumnData(
      name: name ?? this.name,
      type: type ?? this.type,
      nullable: nullable ?? this.nullable,
      defaultValue: defaultValue ?? this.defaultValue,
      primaryKey: primaryKey ?? this.primaryKey,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': formattedName,
      'type': finalizedType.toString(),
      'nullable': nullable,
      'default': defaultValue,
      'primaryKey': primaryKey,
      'foreign_keys': foreignKeys,
      // TODO: need to test and rollout
      // 'unique': unique,
      // 'check': check,
    };
  }
}
