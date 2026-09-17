import 'package:dksoft_market_dealer/features/dashboard/domain/entities/products_summary.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Entry point to the dealer's proposed products list.
class ProductsSummaryTile extends StatelessWidget {
  const ProductsSummaryTile({
    super.key,
    required this.summary,
    required this.onTap,
  });

  final ProductsSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(Sizes.p16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.p16),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Sizes.p10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                child: Icon(Icons.sell_outlined, color: AppColors.primary),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Produits proposés', style: textTheme.bodyMedium),
                    gapH4,
                    Text(
                      '${summary.productsCount} produits · ${summary.merchantsCount} commerçants',
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textHintLight),
            ],
          ),
        ),
      ),
    );
  }
}
