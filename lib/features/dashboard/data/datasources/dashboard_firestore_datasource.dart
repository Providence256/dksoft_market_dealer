import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/data/dealer_repository.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/daily_stats.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/pending_order.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/products_summary.dart';
import 'package:dksoft_market_dealer/features/orders/data/orders_repository.dart';
import 'package:dksoft_market_dealer/features/orders/domain/order_model.dart';

/// Window the dealer has to accept a pending order before it's considered
/// expired, used only to drive the dashboard's countdown card.
const _acceptanceWindow = Duration(minutes: 15);

class DashboardFirestoreDataSource {
  DashboardFirestoreDataSource(
    this._dealerRepository,
    this._ordersRepository,
    this._firestore,
  );
  final DealerRepository _dealerRepository;
  final OrdersRepository _ordersRepository;
  final FirebaseFirestore _firestore;

  Future<DashboardSnapshot> fetchDashboard() async {
    final dealer = await _dealerRepository.watchCurrentDealer().first;

    final productsCount =
        (await _firestore.collection('products').count().get()).count ?? 0;
    final merchantsCount =
        (await _firestore.collection('merchants').count().get()).count ?? 0;

    final orders = await _ordersRepository.watchOrdersForCurrentDealer().first;
    final pendingOrder = orders.cast<OrderModel?>().firstWhere(
      (o) => o!.status == OrderStatus.pending,
      orElse: () => null,
    );

    return DashboardSnapshot(
      dealer: DealerProfile(
        fullName: dealer.fullName,
        initials: _initialsFor(dealer.fullName),
        commune: dealer.address!.commune,
        isVerified: dealer.isValid,
      ),
      wallet: DealerWallet(
        available: dealer.provisionDisponible,
        blocked: dealer.provisionBloquee,
        withdrawable: dealer.provisonRetirable,
      ),
      pendingOrder: pendingOrder == null
          ? null
          : PendingOrder(
              orderNumber: pendingOrder.id,
              amount: pendingOrder.total,
              expiresIn:
                  _acceptanceWindow -
                  DateTime.now().difference(pendingOrder.orderDate),
            ),
      dailyStats: DailyStats(
        date: DateTime.now(),
        ordersCount: orders.length,
        marginEarned: 0,
        deliveredCount: orders
            .where((o) => o.status == OrderStatus.delivered)
            .length,
        cancelledCount: orders
            .where((o) => o.status == OrderStatus.cancelled)
            .length,
      ),
      productsSummary: ProductsSummary(
        productsCount: productsCount,
        merchantsCount: merchantsCount,
      ),
    );
  }

  String _initialsFor(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
