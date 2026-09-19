import 'package:dksoft_market_dealer/core/data/category_seed_repository.dart';
import 'package:dksoft_market_dealer/core/data/dealer_profile_seed_repository.dart';
import 'package:dksoft_market_dealer/core/data/merchant_seed_repository.dart';
import 'package:dksoft_market_dealer/core/data/test_categories.dart';
import 'package:dksoft_market_dealer/core/data/test_dealers.dart';
import 'package:dksoft_market_dealer/core/data/test_merchants.dart';
import 'package:dksoft_market_dealer/core/data/test_products.dart';
import 'package:dksoft_market_dealer/core/domain/brands.dart';
import 'package:dksoft_market_dealer/features/products/data/product_seed_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum SeedStep { brands, categories, merchants, dealerProfiles, products }

/// Immutable progress snapshot the seed screen renders. A fresh instance
/// on every step keeps Riverpod's default identity-based change detection
/// happy — no need for a custom `==`.
class SeedProgress {
  const SeedProgress({
    this.step,
    this.productsDone = 0,
    this.productsTotal = 0,
  });

  final SeedStep? step;
  final int productsDone;
  final int productsTotal;

  SeedProgress copyWith({
    SeedStep? step,
    bool clearStep = false,
    int? productsDone,
    int? productsTotal,
  }) {
    return SeedProgress(
      step: clearStep ? null : (step ?? this.step),
      productsDone: productsDone ?? this.productsDone,
      productsTotal: productsTotal ?? this.productsTotal,
    );
  }
}

/// Runs every fixture seeder. Methods can be called individually (one per
/// collection, same idea as the existing `SeedController.seedBrands`) or
/// all together via [seedAll], which respects the references between
/// fixtures — products point to `brandId`/`categoryId`/`marchandId`, so
/// those collections have to exist first.
class SeedAllController extends StateNotifier<AsyncValue<SeedProgress>> {
  SeedAllController(this._ref) : super(AsyncData(const SeedProgress()));

  final Ref _ref;

  Future<void> _run(SeedStep step, Future<void> Function() action) async {
    state = AsyncData(
      (state.value ?? const SeedProgress()).copyWith(step: step),
    );
    try {
      await action();
      state = AsyncData(
        (state.value ?? const SeedProgress()).copyWith(clearStep: true),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> seedBrands() {
    return _run(
      SeedStep.brands,
      () => _ref.read(seedControllerProvider.notifier).seedBrands(),
    );
  }

  Future<void> seedCategories() {
    return _run(
      SeedStep.categories,
      () => _ref.read(categorySeedRepositoryProvider).seed(kTestCategory),
    );
  }

  Future<void> seedMerchants() {
    return _run(
      SeedStep.merchants,
      () => _ref.read(merchantSeedRepositoryProvider).seed(kTestMerchants),
    );
  }

  Future<void> seedDealerProfiles() {
    return _run(
      SeedStep.dealerProfiles,
      () => _ref.read(dealerProfileSeedRepositoryProvider).seed(kTestDealers),
    );
  }

  Future<void> seedProducts() {
    return _run(SeedStep.products, () async {
      state = AsyncData(
        (state.value ?? const SeedProgress()).copyWith(
          step: SeedStep.products,
          productsDone: 0,
          productsTotal: kTestProducts.length,
        ),
      );
      await _ref
          .read(productSeedRepositoryProvider)
          .seed(
            kTestProducts,
            onProgress: (done, total) {
              state = AsyncData(
                (state.value ?? const SeedProgress()).copyWith(
                  productsDone: done,
                  productsTotal: total,
                ),
              );
            },
          );
    });
  }

  Future<void> seedAll() async {
    await seedBrands();
    if (state.hasError) return;
    await seedCategories();
    if (state.hasError) return;
    await seedMerchants();
    if (state.hasError) return;
    await seedDealerProfiles();
    if (state.hasError) return;
    await seedProducts();
  }
}

final seedAllControllerProvider =
    StateNotifierProvider<SeedAllController, AsyncValue<SeedProgress>>((ref) {
      return SeedAllController(ref);
    });
