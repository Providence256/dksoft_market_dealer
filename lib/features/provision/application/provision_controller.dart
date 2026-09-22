import 'package:dksoft_market_dealer/features/provision/data/provision_repository.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProvisionController extends StateNotifier<AsyncValue<void>> {
  ProvisionController(this._repository) : super(const AsyncData(null));
  final ProvisionRepository _repository;

  Future<bool> submit({
    required ProvisionRequestType type,
    required double amount,
    required String method,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.submitRequest(
        type: type,
        amount: amount,
        method: method,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

final provisionControllerProvider =
    StateNotifierProvider.autoDispose<ProvisionController, AsyncValue<void>>((
      ref,
    ) {
      return ProvisionController(ref.watch(provisionRepositoryProvider));
    });
