// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';

enum DealerStatus { enAttente, valide, suspendu, refuse }

class DealerModel {
  DealerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.address,
    required this.provisionDisponible,
    required this.provisionBloquee,
    required this.provisonRetirable,
    this.status = DealerStatus.valide,
    required this.rating,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final PickupLocation? address;
  final double provisionDisponible;
  final double provisionBloquee;
  final double provisonRetirable;
  final DealerStatus status;
  final double rating;

  double get provisionTotale => provisionDisponible + provisionBloquee;
  bool get isValid => status == DealerStatus.valide;
  bool peutCouvrir(double montant) => isValid && provisionDisponible >= montant;

  DealerModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    PickupLocation? address,
    double? provisionDisponible,
    double? provisionBloquee,
    double? provisonRetirable,
    DealerStatus? status,
    double? rating,
  }) {
    return DealerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      provisionDisponible: provisionDisponible ?? this.provisionDisponible,
      provisionBloquee: provisionBloquee ?? this.provisionBloquee,
      provisonRetirable: provisonRetirable ?? this.provisonRetirable,
      status: status ?? this.status,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address?.toMap(),
      'provisionDisponible': provisionDisponible,
      'provisionBloquee': provisionBloquee,
      'provisonRetirable': provisonRetirable,
      'status': status.name,
      'rating': rating,
    };
  }

  factory DealerModel.fromMap(Map<String, dynamic> map) {
    return DealerModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      address: PickupLocation.fromMap(map['address'] as Map<String, dynamic>),
      provisionDisponible: map['provisionDisponible'] as double,
      provisionBloquee: map['provisionBloquee'] as double,
      provisonRetirable: map['provisonRetirable'] as double,
      status: DealerStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => DealerStatus.enAttente,
      ),
      rating: map['rating'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerModel.fromJson(String source) =>
      DealerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DealerModel(id: $id, fullName: $fullName, phone: $phone, email: $email, address: $address, provisionDisponible: $provisionDisponible, provisionBloquee: $provisionBloquee, provisonRetirable: $provisonRetirable, status: $status, rating: $rating)';
  }

  @override
  bool operator ==(covariant DealerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.provisionDisponible == provisionDisponible &&
        other.provisionBloquee == provisionBloquee &&
        other.provisonRetirable == provisonRetirable &&
        other.status == status &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        address.hashCode ^
        provisionDisponible.hashCode ^
        provisionBloquee.hashCode ^
        provisonRetirable.hashCode ^
        status.hashCode ^
        rating.hashCode;
  }
}
