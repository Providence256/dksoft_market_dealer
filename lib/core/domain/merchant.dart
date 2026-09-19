// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';

class Merchant {
  const Merchant({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    required this.salesCount,
    required this.verified,
    this.pickupLocations = const [],
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final int salesCount;
  final bool verified;
  final List<PickupLocation> pickupLocations;

  PickupLocation? get defaultPickupLocation {
    if (pickupLocations.isEmpty) return null;

    return pickupLocations.first;
  }

  factory Merchant.unknown(String id) => Merchant(
    id: id,
    name: 'Vendeur',
    rating: 0,
    salesCount: 0,
    verified: false,
  );

  Merchant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? rating,
    int? salesCount,
    bool? verified,
    List<PickupLocation>? pickupLocations,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      verified: verified ?? this.verified,
      pickupLocations: pickupLocations ?? this.pickupLocations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'salesCount': salesCount,
      'verified': verified,
      'pickupLocations': pickupLocations
          .map((location) => location.toMap())
          .toList(),
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      rating: (map['rating'] as num).toDouble(),
      salesCount: (map['salesCount'] as num).toInt(),
      verified: map['verified'] as bool? ?? false,
      pickupLocations: (map['pickupLocations'] as List<dynamic>? ?? [])
          .map(
            (location) => PickupLocation.fromMap(
              Map<String, dynamic>.from(location as Map),
            ),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Merchant('
      'id: $id, '
      'name: $name, '
      'rating: $rating, '
      'salesCount: $salesCount, '
      'verified: $verified, '
      'pickupLocations: $pickupLocations'
      ')';

  @override
  bool operator ==(covariant Merchant other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.rating == rating &&
        other.salesCount == salesCount &&
        other.verified == verified &&
        _listEquals(other.pickupLocations, pickupLocations);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatarUrl.hashCode ^
        rating.hashCode ^
        salesCount.hashCode ^
        verified.hashCode ^
        Object.hashAll(pickupLocations);
  }

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
