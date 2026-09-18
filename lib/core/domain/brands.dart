import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/data/test_brands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brands.g.dart';

class Brands {
  const Brands({required this.id, required this.name});
  final String id;
  final String name;

  Brands copyWith({String? id, String? name}) {
    return Brands(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Brands.fromMap(Map<String, dynamic> map) {
    return Brands(id: map['id'] as String, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Brands.fromJson(String source) =>
      Brands.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Brands(id: $id, name: $name)';

  @override
  bool operator ==(covariant Brands other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class BrandSeeder {
  BrandSeeder(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> seed(List<Brands> brands) async {
    final batch = _firestore.batch();

    for (final brand in brands) {
      final docRef = _firestore.collection('brands').doc(brand.id);

      batch.set(docRef, brand.toMap());
    }

    await batch.commit();
  }
}

final brandSeedProvider = Provider<BrandSeeder>((ref) {
  return BrandSeeder(FirebaseFirestore.instance);
});

@Riverpod(keepAlive: true)
class SeedController extends _$SeedController {
  @override
  FutureOr<void> build() {}

  Future<void> seedBrands() async {
    state = AsyncLoading();

    try {
      final seeder = ref.read(brandSeedProvider);

      await seeder.seed(kBrands);

      state = AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
