import 'package:dksoft_market_dealer/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:dksoft_market_dealer/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>(
  (ref) => DashboardLocalDataSource(),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(ref.watch(dashboardLocalDataSourceProvider)),
);

/// Loads and holds the dealer dashboard state for the presentation layer.
class DashboardController extends AsyncNotifier<DashboardSnapshot> {
  @override
  Future<DashboardSnapshot> build() {
    return ref.watch(dashboardRepositoryProvider).getDashboardSnapshot();
  }

  /// Reloads the dashboard, keeping the previous data visible while
  /// the new value is fetched (used by pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading<DashboardSnapshot>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(dashboardRepositoryProvider).getDashboardSnapshot(),
    );
  }
}

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardSnapshot>(
      DashboardController.new,
    );
