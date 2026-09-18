// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductVariation {
  const ProductVariation({
    required this.id,
    required this.price,
    required this.stock,
    required this.attributeValues,
  });

  final String id;
  final double price;
  final int stock;
  final Map<String, String> attributeValues;

  // an Empty function

  static ProductVariation empty() =>
      ProductVariation(id: '', price: 0.0, stock: 0, attributeValues: {});

  ProductVariation copyWith({
    String? id,
    double? price,
    int? stock,
    Map<String, String>? attributeValues,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      attributeValues: attributeValues ?? this.attributeValues,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'price': price,
      'stock': stock,
      'attributeValues': attributeValues,
    };
  }

  factory ProductVariation.fromMap(Map<String, dynamic> map) {
    return ProductVariation(
      id: map['id'] as String,
      price: map['price'] as double,
      stock: map['stock'] as int,
      attributeValues: Map<String, String>.from(
        (map['attributeValues'] as Map<String, String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductVariation.fromJson(String source) =>
      ProductVariation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductVariation(id: $id, price: $price, stock: $stock, attributeValues: $attributeValues)';
  }

  @override
  bool operator ==(covariant ProductVariation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.price == price &&
        other.stock == stock &&
        mapEquals(other.attributeValues, attributeValues);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        attributeValues.hashCode;
  }
}
