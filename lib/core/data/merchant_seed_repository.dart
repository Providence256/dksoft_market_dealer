import 'package:dksoft_market_dealer/core/data/firestore_seeder.dart';
import 'package:dksoft_market_dealer/core/domain/merchant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantSeedRepository {
  MerchantSeedRepository(this._seeder);
  final FirestoreSeeder _seeder;

  Future<void> seed(List<Merchant> merchants) {
    return _seeder.seedCollection<Merchant>(
      'merchants',
      merchants,
      idOf: (merchant) => merchant.id,
      toMap: (merchant) => merchant.toMap(),
    );
  }
}

final merchantSeedRepositoryProvider = Provider<MerchantSeedRepository>((ref) {
  return MerchantSeedRepository(ref.watch(firestoreSeederProvider));
});
