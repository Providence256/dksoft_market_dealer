// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:dksoft_market_dealer/core/domain/product_attribut.dart';
import 'package:dksoft_market_dealer/core/domain/product_variation.dart';
import 'package:flutter/foundation.dart';

class ProductModal {
  const ProductModal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.reduction,
    this.brandId,
    required this.categoryId,
    required this.subCategoryId,
    required this.images,
    this.attributs = const [],
    this.variations = const [],
    required this.stock,
    required this.unit,
    required this.marchandId,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final int reduction;
  final String? brandId;
  final String categoryId;
  final String subCategoryId;
  final List<String> images;
  final List<ProductAttribut> attributs;
  final List<ProductVariation> variations;
  final int stock;
  final String unit;
  final String marchandId;

  ProductModal copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? reduction,
    String? brandId,
    String? categoryId,
    String? subCategoryId,
    List<String>? images,
    List<ProductAttribut>? attributs,
    List<ProductVariation>? variations,
    int? stock,
    String? unit,
    String? marchandId,
  }) {
    return ProductModal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      reduction: reduction ?? this.reduction,
      brandId: brandId ?? this.brandId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      images: images ?? this.images,
      attributs: attributs ?? this.attributs,
      variations: variations ?? this.variations,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      marchandId: marchandId ?? this.marchandId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'reduction': reduction,
      'brandId': brandId,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'images': images,
      'attributs': attributs.map((x) => x.toMap()).toList(),
      'variations': variations.map((x) => x.toMap()).toList(),
      'stock': stock,
      'unit': unit,
      'marchandId': marchandId,
    };
  }

  factory ProductModal.fromMap(Map<String, dynamic> map) {
    return ProductModal(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,

      price: (map['price'] as num).toDouble(),

      reduction: (map['reduction'] as num).toInt(),

      brandId: map['brandId'] != null ? map['brandId'] as String : null,

      categoryId: map['categoryId'] as String,

      subCategoryId: map['subCategoryId'] as String,

      images: List<String>.from(map['images'] ?? []),

      attributs: map['attributs'] != null
          ? List<ProductAttribut>.from(
              (map['attributs'] as List).map(
                (x) => ProductAttribut.fromMap(Map<String, dynamic>.from(x)),
              ),
            )
          : const [],

      variations: map['variations'] != null
          ? List<ProductVariation>.from(
              (map['variations'] as List).map(
                (x) => ProductVariation.fromMap(Map<String, dynamic>.from(x)),
              ),
            )
          : const [],

      stock: (map['stock'] as num).toInt(),

      unit: map['unit'] as String,

      marchandId: map['marchandId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModal.fromJson(String source) {
    return ProductModal.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'ProductModal('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'price: $price, '
        'reduction: $reduction, '
        'brandId: $brandId, '
        'categoryId: $categoryId, '
        'subCategoryId: $subCategoryId, '
        'images: $images, '
        'attributs: $attributs, '
        'variations: $variations, '
        'stock: $stock, '
        'unit: $unit, '
        'marchandId: $marchandId'
        ')';
  }

  @override
  bool operator ==(covariant ProductModal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.reduction == reduction &&
        other.brandId == brandId &&
        other.categoryId == categoryId &&
        other.subCategoryId == subCategoryId &&
        listEquals(other.images, images) &&
        listEquals(other.attributs, attributs) &&
        listEquals(other.variations, variations) &&
        other.stock == stock &&
        other.unit == unit &&
        other.marchandId == marchandId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        reduction.hashCode ^
        brandId.hashCode ^
        categoryId.hashCode ^
        subCategoryId.hashCode ^
        Object.hashAll(images) ^
        Object.hashAll(attributs) ^
        Object.hashAll(variations) ^
        stock.hashCode ^
        unit.hashCode ^
        marchandId.hashCode;
  }
}
