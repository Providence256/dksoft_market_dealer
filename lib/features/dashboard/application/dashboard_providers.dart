import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/data/dealer_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/dashboard/data/datasources/dashboard_firestore_datasource.dart';
import 'package:dksoft_market_dealer/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dksoft_market_dealer/features/orders/data/orders_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardFirestoreDataSourceProvider =
    Provider<DashboardFirestoreDataSource>(
      (ref) => DashboardFirestoreDataSource(
        ref.watch(dealerRepositoryProvider),
        ref.watch(ordersRepositoryProvider),
        FirebaseFirestore.instance,
      ),
    );

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) =>
      DashboardRepositoryImpl(ref.watch(dashboardFirestoreDataSourceProvider)),
);

/// Loads and holds the dealer dashboard state for the presentation layer.
class DashboardController extends AsyncNotifier<DashboardSnapshot> {
  @override
  Future<DashboardSnapshot> build() async {
    await ref.watch(authStateChangesProvider.future);
    return ref.watch(dashboardRepositoryProvider).getDashboardSnapshot();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final dashboardControllerProvider =
    AsyncNotifierProvider.autoDispose<DashboardController, DashboardSnapshot>(
      DashboardController.new,
    );
