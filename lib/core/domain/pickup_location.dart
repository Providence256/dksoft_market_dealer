// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PickupLocation {
  const PickupLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.commune,
    required this.reference,
    required this.latitude,
    required this.longitude,
  });
  final String id;
  final String name;
  final String address;
  final String commune;
  final String reference;
  final double latitude;
  final double longitude;

  PickupLocation copyWith({
    String? id,
    String? name,
    String? address,
    String? commune,
    String? reference,
    double? latitude,
    double? longitude,
  }) {
    return PickupLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      commune: commune ?? this.commune,
      reference: reference ?? this.reference,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'commune': commune,
      'reference': reference,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PickupLocation.fromMap(Map<String, dynamic> map) {
    return PickupLocation(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      commune: map['commune'] as String,
      reference: map['reference'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PickupLocation.fromJson(String source) =>
      PickupLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PickupLocation(id: $id, name: $name, address: $address, commune: $commune, reference: $reference, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant PickupLocation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.address == address &&
        other.commune == commune &&
        other.reference == reference &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        commune.hashCode ^
        reference.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
