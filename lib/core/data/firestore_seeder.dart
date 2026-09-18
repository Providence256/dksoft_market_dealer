import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Writes a list of domain objects to a Firestore collection, one `.set()`
/// per item batched together — the same write pattern `BrandSeeder`
/// already used, factored out so every `*SeedRepository` shares it
/// instead of re-implementing its own batch loop.
class FirestoreSeeder {
  FirestoreSeeder(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> seedCollection<T>(
    String collection,
    List<T> items, {
    required String Function(T item) idOf,
    required Map<String, dynamic> Function(T item) toMap,
  }) async {
    final batch = _firestore.batch();

    for (final item in items) {
      batch.set(_firestore.collection(collection).doc(idOf(item)), toMap(item));
    }

    await batch.commit();
  }
}

final firestoreSeederProvider = Provider<FirestoreSeeder>((ref) {
  return FirestoreSeeder(FirebaseFirestore.instance);
});
