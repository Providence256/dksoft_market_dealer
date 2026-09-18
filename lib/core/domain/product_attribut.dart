// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductAttribut {
  const ProductAttribut({this.name, this.values});
  final String? name;
  final List<String>? values;

  ProductAttribut copyWith({String? name, List<String>? values}) {
    return ProductAttribut(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'values': values};
  }

  factory ProductAttribut.fromMap(Map<String, dynamic> map) {
    return ProductAttribut(
      name: map['name'] != null ? map['name'] as String : null,
      values: map['values'] != null
          ? List<String>.from((map['values'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductAttribut.fromJson(String source) =>
      ProductAttribut.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductAttribut(name: $name, values: $values)';

  @override
  bool operator ==(covariant ProductAttribut other) {
    if (identical(this, other)) return true;

    return other.name == name && listEquals(other.values, values);
  }

  @override
  int get hashCode => name.hashCode ^ values.hashCode;
}
