import 'package:dksoft_market_dealer/core/data/firestore_seeder.dart';
import 'package:dksoft_market_dealer/core/domain/product_modal.dart';
import 'package:dksoft_market_dealer/features/products/data/image_upload_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Uploads every product's local asset images to Storage, then writes the
/// product — with Storage download URLs swapped in for the asset paths —
/// to Firestore. [onProgress] lets a seed screen show "3/15 produits
/// envoyés" while the uploads run.
class ProductSeedRepository {
  ProductSeedRepository(this._imageUploadRepository, this._seeder);

  final ImageUploadRepository _imageUploadRepository;
  final FirestoreSeeder _seeder;

  Future<void> seed(
    List<ProductModal> products, {
    void Function(int done, int total)? onProgress,
  }) async {
    final withUploadedImages = <ProductModal>[];

    for (var i = 0; i < products.length; i++) {
      final product = products[i];
      final downloadUrls = await _imageUploadRepository
          .uploadProductImageFromAsset(product.images, product.id);
      withUploadedImages.add(product.copyWith(images: downloadUrls));
      onProgress?.call(i + 1, products.length);
    }

    await _seeder.seedCollection<ProductModal>(
      'products',
      withUploadedImages,
      idOf: (product) => product.id,
      toMap: (product) => product.toMap(),
    );
  }
}

final productSeedRepositoryProvider = Provider<ProductSeedRepository>((ref) {
  return ProductSeedRepository(
    ref.watch(imageUploadRepositoryProvider),
    ref.watch(firestoreSeederProvider),
  );
});
