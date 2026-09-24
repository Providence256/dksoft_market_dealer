import 'package:dksoft_market_dealer/common/async_value_widget.dart';
import 'package:dksoft_market_dealer/features/orders/data/orders_repository.dart';
import 'package:dksoft_market_dealer/features/orders/domain/order_model.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderValue = ref.watch(orderStreamProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de la commande',
          style: Theme.of(context).textTheme.titleLarge!
              .copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: AsyncValueWidget(
        value: orderValue,
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Commande introuvable.'));
          }
          return _OrderDetails(order: order);
        },
      ),
    );
  }
}

class _OrderDetails extends ConsumerWidget {
  const _OrderDetails({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final client = ref.watch(dealerByIdProvider(order.userId));
    final items = order.toOrderItems();

    return ListView(
      padding: const EdgeInsets.all(Sizes.p20),
      children: [
        Text(
          '#${order.id}',
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Sizes.p4),
        Text(
          'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(order.orderDate)}',
          style: theme.textTheme.labelMedium!.copyWith(
            color: AppColors.textHintLight,
          ),
        ),
        const SizedBox(height: Sizes.p16),
        Row(
          children: [
            StatusChip(status: order.orderStatus),
            const Spacer(),
            InkWell(
              onTap: () => context.goNamed(
                AppRoute.orderTracking.name,
                pathParameters: {'orderId': order.id},
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Suivi de commande',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.p20),
        Container(
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.dividerLight),
            borderRadius: BorderRadius.circular(Sizes.p16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  dealer != null && dealer.fullName.isNotEmpty
                      ? dealer.fullName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: Sizes.p12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dealer',
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: AppColors.textHintLight,
                      ),
                    ),
                    Text(
                      dealer?.fullName ?? 'Dealer',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _IconAction(
                icon: Icons.call_outlined,
                onTap: () => _showComingSoon(context, "l'appel"),
              ),
              const SizedBox(width: Sizes.p8),
              _IconAction(
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () => _showComingSoon(context, 'la messagerie'),
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.p24),
        Text(
          'Articles',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const CustomDivider(),
          Builder(
            builder: (_) {
              final item = items[i];
              final productValue = ref.watch(
                productStreamProvider(item.productId),
              );
              final product = productValue.value;
              if (product == null) return const SizedBox.shrink();
              return PaymentCartLineRow(product: product, item: item);
            },
          ),
        ],

        const Divider(color: AppColors.dividerLight),
        const SizedBox(height: Sizes.p8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Total:',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: Sizes.p8),
            Text(
              CurrencyFormatter.format(order.total),
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accès à $label bientôt disponible.')),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
