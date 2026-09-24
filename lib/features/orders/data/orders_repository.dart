import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/features/orders/domain/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'orders_repository.g.dart';

class OrdersRepository {
  OrdersRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static String ordersPath() => 'orders';
  static String orderPath(String id) => 'orders/$id';

  Stream<List<OrderModel>> watchOrdersForCurrentDealer() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('orders')
        .where('dealerId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList();
          orders.sort((lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate));
          return orders;
        });
  }

  Stream<OrderModel?> watchDealerOrder(String orderId) {
    return watchOrdersForCurrentDealer().map(
      (orders) => _getOrder(orders, orderId),
    );
  }

  //Stream<OrderModel?> watchUserOrder(String uid, String orderId) {}

  DocumentReference<OrderModel> _orderRef(String id) => _firestore
      .doc(orderPath(id))
      .withConverter(
        fromFirestore: (doc, _) => OrderModel.fromMap(doc.data()!),
        toFirestore: (OrderModel order, options) => order.toMap(),
      );

  Query<OrderModel> _ordersRef() => _firestore
      .collection(ordersPath())
      .withConverter(
        fromFirestore: (doc, _) => OrderModel.fromMap(doc.data()!),
        toFirestore: (OrderModel order, options) => order.toMap(),
      )
      .orderBy('id');

  static OrderModel? _getOrder(List<OrderModel> orders, String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

/// Live list of every order for the connected dealer, newest first.
final dealerOrdersProvider = StreamProvider.autoDispose<List<OrderModel>>((
  ref,
) {
  return ref.watch(ordersRepositoryProvider).watchOrdersForCurrentDealer();
});

/// The most recent order still awaiting the dealer's validation, if any —
/// drives the dashboard's notification card.
final pendingOrderProvider = Provider.autoDispose<AsyncValue<OrderModel?>>((
  ref,
) {
  final orders = ref.watch(dealerOrdersProvider);
  return orders.whenData(
    (list) => list.cast<OrderModel?>().firstWhere(
      (o) => o!.status == OrderStatus.pending,
      orElse: () => null,
    ),
  );
});

@riverpod
Stream<OrderModel?> orderStream(Ref ref, String id) {
  final repository = ref.watch(ordersRepositoryProvider);
  return repository.watchDealerOrder(id);
}
