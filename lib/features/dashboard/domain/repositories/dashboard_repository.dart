import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';

/// Contract the application layer depends on to load the dealer dashboard.
/// The data layer provides the implementation (mock today, API later)
/// without this contract ever changing.
abstract class DashboardRepository {
  Future<DashboardSnapshot> getDashboardSnapshot();
}
