import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, accepted, shipped, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => OrderStatus.pending,
    );
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.accepted:
        return 'Acceptée';
      case OrderStatus.shipped:
        return 'En livraison';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }
}

/// Mirrors the order document written by the client app to the shared
/// `orders` Firestore collection.

class OrderModel {
  const OrderModel({
    required this.id,
    required this.userId,
    required this.dealerId,
    required this.items,
    required this.status,
    required this.orderDate,
    required this.total,
  });

  final String id;
  final String userId;
  final String dealerId;
  final Map<String, int> items;
  final OrderStatus status;
  final DateTime orderDate;
  final double total;

  int get itemsCount {
    return items.values.fold(0, (sum, quantity) => sum + quantity);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'dealerId': dealerId,
      'items': items,
      'orderStatus': status.name,
      'orderDate': Timestamp.fromDate(orderDate),
      'total': total,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final rawOrderDate = map['orderDate'];

    final DateTime orderDate;

    if (rawOrderDate is Timestamp) {
      orderDate = rawOrderDate.toDate();
    } else if (rawOrderDate is String) {
      orderDate = DateTime.tryParse(rawOrderDate) ?? DateTime.now();
    } else if (rawOrderDate is DateTime) {
      orderDate = rawOrderDate;
    } else {
      orderDate = DateTime.now();
    }

    final rawItems = map['items'];

    final Map<String, int> items;

    if (rawItems is Map) {
      items = rawItems.map((key, value) {
        return MapEntry(key.toString(), (value as num).toInt());
      });
    } else {
      items = {};
    }

    return OrderModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      dealerId: map['dealerId']?.toString() ?? '',
      items: items,
      status: OrderStatusLabel.fromString(
        map['orderStatus']?.toString() ?? 'pending',
      ),
      orderDate: orderDate,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? dealerId,
    Map<String, int>? items,
    OrderStatus? status,
    DateTime? orderDate,
    double? total,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dealerId: dealerId ?? this.dealerId,
      items: items ?? this.items,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return 'OrderModel('
        'id: $id, '
        'userId: $userId, '
        'dealerId: $dealerId, '
        'items: $items, '
        'status: $status, '
        'orderDate: $orderDate, '
        'total: $total'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.userId == userId &&
        other.dealerId == dealerId &&
        _mapEquals(other.items, items) &&
        other.status == status &&
        other.orderDate == orderDate &&
        other.total == total;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      dealerId,
      Object.hashAll(
        items.entries.map((entry) => Object.hash(entry.key, entry.value)),
      ),
      status,
      orderDate,
      total,
    );
  }

  static bool _mapEquals(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;

    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }
}
