import 'package:dksoft_market_dealer/exceptions/app_exception.dart';
import 'package:dksoft_market_dealer/features/dashboard/data/datasources/dashboard_firestore_datasource.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dataSource);

  final DashboardFirestoreDataSource _dataSource;

  @override
  Future<DashboardSnapshot> getDashboardSnapshot() async {
    try {
      return await _dataSource.fetchDashboard();
    } catch (e) {
      throw DashboardLoadFailureException(e.toString());
    }
  }
}
