import 'package:dksoft_market_dealer/core/domain/merchant.dart';
import 'package:dksoft_market_dealer/core/domain/product_modal.dart';
import 'package:dksoft_market_dealer/features/catalog/data/product_catalog_repository.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Two tabs, one screen, since both lists read the same two collections
/// and a dealer moves between them constantly ("which merchant is this
/// product from?").
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Produits & marchands',
          style: Theme.of(context).textTheme.headlineSmall!
              .copyWith(color: AppColors.primary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.bodyMedium!
              .copyWith(color: AppColors.primary),
          tabs: [
            Tab(text: 'Produits'),
            Tab(text: 'Marchands'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_ProductsTab(), _MerchantsTab()],
      ),
    );
  }
}

class _ProductsTab extends ConsumerWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(catalogProductsProvider);
    final merchantsAsync = ref.watch(catalogMerchantsProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (products) {
        final merchantNames = <String, String>{
          for (final merchant in merchantsAsync.value ?? <Merchant>[])
            merchant.id: merchant.name,
        };

        if (products.isEmpty) {
          return const Center(child: Text('Aucun produit pour le moment.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(Sizes.p16),
          itemCount: products.length,
          separatorBuilder: (_, _) => gapH8,
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductTile(
              product: product,
              merchantName: merchantNames[product.marchandId] ?? 'Marchand',
            );
          },
        );
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.merchantName});

  final ProductModal product;
  final String merchantName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasReduction = product.reduction > 0;
    final discountedPrice = hasReduction
        ? product.price * (1 - product.reduction / 100)
        : product.price;
    final inStock = product.stock > 0;

    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.p8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: product.images.isNotEmpty
                  ? Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _ImagePlaceholder(),
                    )
                  : _ImagePlaceholder(),
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                gapH4,
                Text(
                  merchantName,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                gapH4,
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.formatUsd(discountedPrice),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    if (hasReduction) ...[
                      gapW8,
                      Text(
                        CurrencyFormatter.formatUsd(product.price),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.error,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (inStock ? AppColors.success : AppColors.error).withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(Sizes.p8),
            ),
            child: Text(
              inStock ? 'En stock' : 'Rupture',
              style: textTheme.labelSmall?.copyWith(
                color: inStock ? AppColors.success : AppColors.error,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dividerLight,
      child: Icon(Icons.image_outlined, color: AppColors.textHintLight),
    );
  }
}

class _MerchantsTab extends ConsumerWidget {
  const _MerchantsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(catalogMerchantsProvider);
    final productsAsync = ref.watch(catalogProductsProvider);

    return merchantsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (merchants) {
        if (merchants.isEmpty) {
          return Center(
            child: Text(
              'Aucun marchand pour le moment.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        }

        final productCounts = <String, int>{};
        for (final product in productsAsync.value ?? <ProductModal>[]) {
          productCounts[product.marchandId] =
              (productCounts[product.marchandId] ?? 0) + 1;
        }

        return ListView.separated(
          padding: const EdgeInsets.all(Sizes.p16),
          itemCount: merchants.length,
          separatorBuilder: (_, _) => gapH8,
          itemBuilder: (context, index) {
            final merchant = merchants[index];
            return _MerchantTile(
              merchant: merchant,
              productsCount: productCounts[merchant.id] ?? 0,
            );
          },
        );
      },
    );
  }
}

class _MerchantTile extends StatelessWidget {
  const _MerchantTile({required this.merchant, required this.productsCount});

  final Merchant merchant;
  final int productsCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final commune = merchant.defaultPickupLocation?.commune;

    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: merchant.avatarUrl != null
                ? NetworkImage(merchant.avatarUrl!)
                : null,
            child: merchant.avatarUrl == null
                ? Text(
                    merchant.name.isNotEmpty
                        ? merchant.name.substring(0, 1).toUpperCase()
                        : '?',
                    style: TextStyle(color: AppColors.primary),
                  )
                : null,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        merchant.name,
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (merchant.verified) ...[
                      gapW4,
                      Icon(Icons.verified, size: 14, color: AppColors.success),
                    ],
                  ],
                ),
                gapH4,
                Text(
                  [
                    if (commune != null && commune.isNotEmpty) commune,
                    '$productsCount produit${productsCount > 1 ? 's' : ''}',
                  ].join(' · '),
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: AppColors.secondary),
              const SizedBox(width: 2),
              Text(
                merchant.rating.toStringAsFixed(1),
                style: textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
