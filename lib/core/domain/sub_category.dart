// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubCategory {
  const SubCategory({required this.id, required this.name});
  final String id;
  final String name;

  SubCategory copyWith({String? id, String? name}) {
    return SubCategory(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(id: map['id'] as String, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubCategory(id: $id, name: $name)';

  @override
  bool operator ==(covariant SubCategory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
