import 'package:dksoft_market_dealer/features/dashboard/domain/entities/daily_stats.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/pending_order.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/products_summary.dart';

/// First-version data source for the dealer dashboard.
///
/// It returns fixed sample data so the application and presentation
/// layers can be built and reviewed before the backend exists. Swap the
/// body of [fetchDashboard] for a real API call once it's ready — the
/// [DashboardRepository] contract it serves stays unchanged.
class DashboardLocalDataSource {
  Future<DashboardSnapshot> fetchDashboard() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return DashboardSnapshot(
      dealer: const DealerProfile(
        fullName: 'Papa Jean D.',
        initials: 'PJ',
        commune: 'Ngaba',
        isVerified: true,
      ),
      wallet: const DealerWallet(
        available: 150.00,
        blocked: 100.00,
        withdrawable: 27.50,
      ),
      pendingOrder: const PendingOrder(
        orderNumber: 'KIN-4821',
        amount: 105.00,
        expiresIn: Duration(minutes: 8, seconds: 12),
      ),
      dailyStats: DailyStats(
        date: DateTime.now(),
        ordersCount: 6,
        marginEarned: 14.20,
        deliveredCount: 4,
        cancelledCount: 1,
      ),
      productsSummary: const ProductsSummary(
        productsCount: 32,
        merchantsCount: 4,
      ),
    );
  }
}
