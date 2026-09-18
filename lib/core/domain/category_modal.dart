// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dksoft_market_dealer/core/domain/sub_category.dart';
import 'package:flutter/foundation.dart';

class CategoryModal {
  const CategoryModal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subCategory = const [],
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<SubCategory> subCategory;

  CategoryModal copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<SubCategory>? subCategory,
  }) {
    return CategoryModal(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      subCategory: subCategory ?? this.subCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'subCategory': subCategory.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModal.fromMap(Map<String, dynamic> map) {
    return CategoryModal(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      subCategory: List<SubCategory>.from(
        (map['subCategory'] as List<int>).map<SubCategory>(
          (x) => SubCategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModal.fromJson(String source) =>
      CategoryModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, imageUrl: $imageUrl, subCategory: $subCategory)';
  }

  @override
  bool operator ==(covariant CategoryModal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        listEquals(other.subCategory, subCategory);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        subCategory.hashCode;
  }
}
