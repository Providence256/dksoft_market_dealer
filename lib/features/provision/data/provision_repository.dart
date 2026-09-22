import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Requests live under the dealer's own doc
/// (`dealers/{uid}/provisionRequests`), not a top-level collection — a
/// dealer only ever needs to read/write their own, which keeps the
/// security rules simple (owner-only), and it's naturally where the
/// wallet's history belongs.
class ProvisionRepository {
  ProvisionRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _requestsRef(String uid) {
    return _firestore
        .collection(AuthRepository.dealersPath())
        .doc(uid)
        .collection('provisionRequests');
  }

  /// TEST MODE: credits/debits the wallet immediately and logs the
  /// request as already `validee` — there's no back office yet to
  /// validate it separately, so this stands in for that step. A real
  /// admin-validation flow (§5.5/§12.3 — protection contre les fausses
  /// commandes) should replace this before shipping: the request would
  /// start at `enAttente` and only an admin action would move the money.
  Future<void> submitRequest({
    required ProvisionRequestType type,
    required double amount,
    required String method,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('submitRequest called with no signed-in user.');
    }

    final dealerRef = _firestore
        .collection(AuthRepository.dealersPath())
        .doc(uid);
    final requestRef = _requestsRef(uid).doc();

    await _firestore.runTransaction((transaction) async {
      final dealerSnapshot = await transaction.get(dealerRef);
      final data = dealerSnapshot.data();
      if (!dealerSnapshot.exists || data == null) {
        throw StateError('No dealer profile found for $uid.');
      }

      if (type == ProvisionRequestType.retrait) {
        final withdrawable = (data['provisonRetirable'] as num).toDouble();
        if (amount > withdrawable) {
          throw (
            'Montant supérieur à vos gains retirables '
                '(${withdrawable.toStringAsFixed(2)} USD).',
          );
        }
      }

      transaction.update(dealerRef, {
        if (type == ProvisionRequestType.depot)
          'provisionDisponible': FieldValue.increment(amount)
        else
          'provisonRetirable': FieldValue.increment(-amount),
      });

      transaction.set(requestRef, {
        'type': type.name,
        'amount': amount,
        'method': method,
        'status': ProvisionRequestStatus.validee.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<List<ProvisionRequest>> watchRequests() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _requestsRef(uid)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ProvisionRequest(
              id: doc.id,
              type: ProvisionRequestType.values.firstWhere(
                (t) => t.name == data['type'],
                orElse: () => ProvisionRequestType.depot,
              ),
              amount: (data['amount'] as num).toDouble(),
              method: data['method'] as String? ?? '',
              status: ProvisionRequestStatus.values.firstWhere(
                (s) => s.name == data['status'],
                orElse: () => ProvisionRequestStatus.enAttente,
              ),
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          }).toList();
        });
  }
}

final provisionRepositoryProvider = Provider<ProvisionRepository>((ref) {
  return ProvisionRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

final provisionRequestsProvider =
    StreamProvider.autoDispose<List<ProvisionRequest>>((ref) {
      return ref.watch(provisionRepositoryProvider).watchRequests();
    });
