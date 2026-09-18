import 'package:dksoft_market_dealer/core/domain/product_modal.dart';
import 'package:dksoft_market_dealer/features/products/data/image_upload_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'upload_controller.g.dart';

@riverpod
class UploadController extends _$UploadController {
  @override
  FutureOr<void> build() {}

  Future<void> upload(ProductModal product) async {
    try {
      state = AsyncLoading();

      final imageRepository = ref.read(imageUploadRepositoryProvider);

      final downloadUrls = await imageRepository.uploadProductImageFromAsset(
        product.images,
        product.id,
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
