import 'package:dksoft_market_dealer/core/data/dealer_repository.dart';
import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_wallet.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/provision_card.dart';
import 'package:dksoft_market_dealer/features/provision/data/provision_repository.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:dksoft_market_dealer/utils/formatters/date_formatter_fr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  void _openRequestScreen(BuildContext context, ProvisionRequestType type) {
    context.goNamed(AppRoute.provisionRequest.name, extra: type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealerAsync = ref.watch(currentDealerProvider);
    final requestsAsync = ref.watch(provisionRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portefeuille',
          style: Theme.of(context).textTheme.headlineMedium!
              .copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: dealerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p24),
              child: Text('$error', textAlign: TextAlign.center),
            ),
          ),
          data: (dealer) {
            final wallet = DealerWallet(
              available: dealer.provisionDisponible,
              blocked: dealer.provisionBloquee,
              withdrawable: dealer.provisonRetirable,
            );

            return ListView(
              padding: const EdgeInsets.all(Sizes.p16),
              children: [
                ProvisionCard(
                  wallet: wallet,
                  onAlimenter: () =>
                      _openRequestScreen(context, ProvisionRequestType.depot),
                  onRetirer: () =>
                      _openRequestScreen(context, ProvisionRequestType.retrait),
                ),
                gapH24,
                Text(
                  'Historique',
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(color: AppColors.primary),
                ),
                gapH12,
                requestsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('$error'),
                  data: (requests) {
                    if (requests.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.p24,
                        ),
                        child: Center(
                          child: Text(
                            'Aucune opération pour le moment.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondaryLight),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: requests
                          .map((request) => _RequestTile(request: request))
                          .toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request});

  final ProvisionRequest request;

  @override
  Widget build(BuildContext context) {
    final isDeposit = request.type == ProvisionRequestType.depot;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.p8),
            decoration: BoxDecoration(
              color: (isDeposit ? AppColors.success : AppColors.secondary)
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              size: 18,
              color: isDeposit ? AppColors.success : AppColors.secondary,
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDeposit ? 'Alimentation' : 'Retrait',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  '${request.method} · ${DateFormatterFr.dayLabel(request.createdAt)}',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatUsd(request.amount),
                style: textTheme.labelLarge,
              ),
              _StatusBadge(status: request.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ProvisionRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ProvisionRequestStatus.enAttente => ('En attente', AppColors.secondary),
      ProvisionRequestStatus.validee => ('Validée', AppColors.success),
      ProvisionRequestStatus.refusee => ('Refusée', AppColors.error),
    };

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.p8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
