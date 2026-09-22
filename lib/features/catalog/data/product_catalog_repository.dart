import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/domain/merchant.dart';
import 'package:dksoft_market_dealer/core/domain/product_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the `products` and `merchants` collections seeded by
/// SeedAllController — what a dealer browses to pick what to propose to
/// clients (§5.4: "Consultation des produits disponibles chez les
/// commerçants").
class ProductCatalogRepository {
  ProductCatalogRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<List<ProductModal>> watchProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModal.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<List<Merchant>> watchMerchants() {
    return _firestore
        .collection('merchants')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Merchant.fromMap(doc.data())).toList(),
        );
  }
}

final productCatalogRepositoryProvider = Provider<ProductCatalogRepository>((
  ref,
) {
  return ProductCatalogRepository(FirebaseFirestore.instance);
});

final catalogProductsProvider = StreamProvider.autoDispose<List<ProductModal>>((
  ref,
) {
  return ref.watch(productCatalogRepositoryProvider).watchProducts();
});

final catalogMerchantsProvider = StreamProvider.autoDispose<List<Merchant>>((
  ref,
) {
  return ref.watch(productCatalogRepositoryProvider).watchMerchants();
});
