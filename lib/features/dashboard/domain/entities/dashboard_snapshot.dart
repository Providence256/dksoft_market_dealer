import 'package:dksoft_market_dealer/features/dashboard/domain/entities/daily_stats.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/pending_order.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/products_summary.dart';

/// Aggregate of everything the dealer home dashboard needs to render,
/// assembled by the domain layer so presentation only ever depends on
/// this one contract.
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.dealer,
    required this.wallet,
    required this.dailyStats,
    required this.productsSummary,
    this.pendingOrder,
  });

  final DealerProfile dealer;
  final DealerWallet wallet;
  final DailyStats dailyStats;
  final ProductsSummary productsSummary;

  /// Null when the dealer has no order currently awaiting validation.
  final PendingOrder? pendingOrder;
}
