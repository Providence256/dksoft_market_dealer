import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Writes the dealer's pickup/business address — collected once, right
/// after sign-up (see AddressScreen) — onto their existing `dealers/{uid}`
/// doc. Uses `.update()`, not `.set()`, so only the `address` field is
/// touched; the wallet fields seeded at sign-up are left untouched.
class AddressRepository {
  AddressRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> saveDealerAddress(PickupLocation address) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('saveDealerAddress called with no signed-in user.');
    }

    await _firestore.collection(AuthRepository.dealersPath()).doc(uid).update({
      'address': address.toMap(),
    });
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});
