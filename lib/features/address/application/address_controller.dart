import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';
import 'package:dksoft_market_dealer/features/address/data/address_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AddressController extends StateNotifier<AsyncValue<void>> {
  AddressController(this._repository) : super(const AsyncData(null));

  final AddressRepository _repository;

  Future<bool> save(PickupLocation address) async {
    state = const AsyncLoading();
    try {
      await _repository.saveDealerAddress(address);
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

final addressControllerProvider =
    StateNotifierProvider.autoDispose<AddressController, AsyncValue<void>>((
      ref,
    ) {
      return AddressController(ref.watch(addressRepositoryProvider));
    });
