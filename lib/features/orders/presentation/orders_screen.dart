import 'package:dksoft_market_dealer/features/orders/data/orders_repository.dart';
import 'package:dksoft_market_dealer/features/orders/domain/order_model.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:dksoft_market_dealer/utils/formatters/date_formatter_fr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(dealerOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Commandes',
          style: Theme.of(context).textTheme.headlineMedium!
              .copyWith(color: AppColors.primary),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('Aucune commande pour le moment.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(dealerOrdersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(Sizes.p16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => gapH8,
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  Color _statusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.accepted:
      case OrderStatus.shipped:
        return AppColors.info;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.goNamed(
        AppRoute.orderDetails.name,
        pathParameters: {'orderId': order.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(Sizes.p16),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${order.id}', style: textTheme.labelLarge),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Sizes.p8),
                  ),
                  child: Text(
                    order.status.label,
                    style: textTheme.labelSmall?.copyWith(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            gapH8,
            Text(
              DateFormatterFr.dayLabel(order.orderDate),
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            gapH8,
            Text(
              '${order.itemsCount} article(s) - ${CurrencyFormatter.formatUsd(order.total)}',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
