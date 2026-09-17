import 'package:dksoft_market_dealer/features/dashboard/domain/entities/daily_stats.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:dksoft_market_dealer/utils/formatters/date_formatter_fr.dart';
import 'package:flutter/material.dart';

/// 2x2 grid of today's activity — commandes, marge, livrées, annulées —
/// matching the dashboard indicators in §5.9 of the cahier des charges.
class DailyStatsGrid extends StatelessWidget {
  const DailyStatsGrid({super.key, required this.stats});

  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aujourd'hui", style: textTheme.headlineSmall),
            Text(
              DateFormatterFr.dayLabel(stats.date),
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        gapH12,
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Commandes',
                value: '${stats.ordersCount}',
              ),
            ),
            gapW12,
            Expanded(
              child: _StatTile(
                label: 'Marge gagnée',
                value: CurrencyFormatter.formatUsd(stats.marginEarned),
                valueColor: AppColors.success,
              ),
            ),
          ],
        ),
        gapH12,
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Livrées',
                value: '${stats.deliveredCount}',
              ),
            ),
            gapW12,
            Expanded(
              child: _StatTile(
                label: 'Annulées',
                value: '${stats.cancelledCount}',
                valueColor: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(Sizes.p16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          gapH8,
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: valueColor ?? AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
