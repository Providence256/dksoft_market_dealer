import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/data/dealer_repository.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/daily_stats.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/products_summary.dart';

class DashboardFirestoreDataSource {
  DashboardFirestoreDataSource(this._dealerRepository, this._firestore);
  final DealerRepository _dealerRepository;
  final FirebaseFirestore _firestore;

  Future<DashboardSnapshot> fetchDashboard() async {
    final dealer = await _dealerRepository.watchCurrentDealer().first;

    final productsCount =
        (await _firestore.collection('products').count().get()).count ?? 0;
    final merchantsCount =
        (await _firestore.collection('merchants').count().get()).count ?? 0;

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
      pendingOrder: null,
      dailyStats: DailyStats(
        date: DateTime.now(),
        ordersCount: 0,
        marginEarned: 0,
        deliveredCount: 0,
        cancelledCount: 0,
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
