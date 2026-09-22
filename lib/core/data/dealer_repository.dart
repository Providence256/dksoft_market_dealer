import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/domain/dealer_model.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the signed-in dealer's own `dealers/{uid}` document — the same
/// doc AuthRepository seeds at sign-up and AddressScreen completes.
/// Shared by every screen that needs the connected dealer's profile or
/// wallet (dashboard, portefeuille) so there's one Firestore query and
/// one mapping to [DealerModel], not one per screen.
class DealerRepository {
  DealerRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Live stream of the connected dealer's profile/wallet — balance
  /// changes (a top-up gets validated, an order blocks/releases
  /// provision...) reflect immediately, no manual refresh needed.
  Stream<DealerModel> watchCurrentDealer() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.error(
        StateError('watchCurrentDealer called with no signed-in user.'),
      );
    }

    return _firestore
        .collection(AuthRepository.dealersPath())
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (!snapshot.exists || data == null) {
            throw StateError(
              'No dealer profile found for $uid — sign-up may not have '
              'finished writing it.',
            );
          }
          return DealerModel.fromMap(data);
        });
  }
}

final dealerRepositoryProvider = Provider<DealerRepository>((ref) {
  return DealerRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

/// Live, auto-disposed view of the connected dealer — the single provider
/// every screen should watch for "the current dealer's data".
final currentDealerProvider = StreamProvider.autoDispose<DealerModel>((ref) {
  return ref.watch(dealerRepositoryProvider).watchCurrentDealer();
});
