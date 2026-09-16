import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';

/// Hero card summarising the dealer's provision balance — disponible,
/// bloqué and retirable — per §5.5 of the cahier des charges.
class ProvisionCard extends StatelessWidget {
  const ProvisionCard({
    super.key,
    required this.wallet,
    required this.onAlimenter,
    required this.onRetirer,
  });

  final DealerWallet wallet;
  final VoidCallback onAlimenter;
  final VoidCallback onRetirer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.p20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provision disponible',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.normal,
            ),
          ),
          gapH8,
          Text(
            CurrencyFormatter.formatUsd(wallet.available),
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          gapH20,
          Row(
            children: [
              Expanded(
                child: _WalletStat(label: 'Bloqué', value: wallet.blocked),
              ),
              gapW12,
              Expanded(
                child: _WalletStat(
                  label: 'Gains retirables',
                  value: wallet.withdrawable,
                ),
              ),
            ],
          ),
          gapH20,
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAlimenter,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Alimenter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
                  ),
                ),
              ),
              gapW12,
              Expanded(
                child: OutlinedButton(
                  onPressed: onRetirer,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
                  ),
                  child: const Text('Retirer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  const _WalletStat({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.normal,
            ),
          ),
          gapH4,
          Text(
            CurrencyFormatter.formatUsd(value),
            style: textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
