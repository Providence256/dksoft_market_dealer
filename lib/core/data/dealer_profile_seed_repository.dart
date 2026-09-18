import 'package:dksoft_market_dealer/core/data/firestore_seeder.dart';
import 'package:dksoft_market_dealer/core/domain/dealer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seeds a public *directory* of demo dealers (rating, zone, provision —
/// what the client app shows when a customer picks a dealer, §4.3 step 6).
///
/// This is intentionally NOT the `dealers/{uid}` collection: that one is
/// each real dealer's private provision wallet, written by
/// [AuthRepository.signUpWithPhoneAndPassword] at sign-up and keyed by
/// Firebase Auth uid with a different shape (`provisionAvailable`,
/// `isVerified`...). Mixing the two would corrupt both. This seeder writes
/// to `dealer_profiles` instead.
class DealerProfileSeedRepository {
  DealerProfileSeedRepository(this._seeder);
  final FirestoreSeeder _seeder;

  Future<void> seed(List<Dealer> dealers) {
    return _seeder.seedCollection<Dealer>(
      'dealer_profiles',
      dealers,
      idOf: (dealer) => dealer.id,
      toMap: (dealer) => dealer.toMap(),
    );
  }
}

final dealerProfileSeedRepositoryProvider = Provider<DealerProfileSeedRepository>((
  ref,
) {
  return DealerProfileSeedRepository(ref.watch(firestoreSeederProvider));
});
