import 'package:dksoft_market_dealer/core/data/firestore_seeder.dart';
import 'package:dksoft_market_dealer/core/domain/category_modal.dart';
import 'package:dksoft_market_dealer/features/products/data/image_upload_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Uploads each category's local asset thumbnail to Storage, then writes
/// the category — with the Storage download URL swapped in for the asset
/// path — to Firestore. Sub-categories are embedded, matching
/// [CategoryModal.toMap].
class CategorySeedRepository {
  CategorySeedRepository(this._imageUploadRepository, this._seeder);

  final ImageUploadRepository _imageUploadRepository;
  final FirestoreSeeder _seeder;

  Future<void> seed(List<CategoryModal> categories) async {
    final withUploadedImages = <CategoryModal>[];

    for (final category in categories) {
      final downloadUrl = await _imageUploadRepository.uploadImageFromAsset(
        assetPath: category.imageUrl,
        storagePath: 'categories/${category.id}.png',
      );
      withUploadedImages.add(category.copyWith(imageUrl: downloadUrl));
    }

    await _seeder.seedCollection<CategoryModal>(
      'categories',
      withUploadedImages,
      idOf: (category) => category.id,
      toMap: (category) => category.toMap(),
    );
  }
}

final categorySeedRepositoryProvider = Provider<CategorySeedRepository>((ref) {
  return CategorySeedRepository(
    ref.watch(imageUploadRepositoryProvider),
    ref.watch(firestoreSeederProvider),
  );
});
