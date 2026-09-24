import 'package:dksoft_market_dealer/features/dashboard/application/dashboard_providers.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/daily_stats_grid.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/dealer_dashboard_header.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/pending_order_card.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/products_summary_tile.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/widgets/provision_card.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _DashboardError(
            message: error.toString(),
            onRetry: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
          ),
          data: (snapshot) => RefreshIndicator(
            onRefresh: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p16,
                Sizes.p8,
                Sizes.p16,
                Sizes.p32,
              ),
              children: [
                DealerDashboardHeader(dealer: snapshot.dealer),
                gapH20,
                ProvisionCard(
                  wallet: snapshot.wallet,
                  onAlimenter: () => context.goNamed(
                    AppRoute.provisionRequest.name,
                    extra: ProvisionRequestType.depot,
                  ),
                  onRetirer: () => context.goNamed(
                    AppRoute.provisionRequest.name,
                    extra: ProvisionRequestType.retrait,
                  ),
                ),
                if (snapshot.pendingOrder != null) ...[
                  gapH16,
                  PendingOrderCard(
                    order: snapshot.pendingOrder!,
                    onViewOrder: () => context.goNamed(AppRoute.commandes.name),
                  ),
                ],
                gapH24,
                DailyStatsGrid(stats: snapshot.dailyStats),
                gapH16,
                ProductsSummaryTile(
                  summary: snapshot.productsSummary,
                  onTap: () => context.goNamed(AppRoute.catalog.name),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 40),
            gapH12,
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            gapH4,
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
            gapH16,
            ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
