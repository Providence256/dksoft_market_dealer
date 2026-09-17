import 'dart:async';

import 'package:dksoft_market_dealer/features/dashboard/domain/entities/pending_order.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:dksoft_market_dealer/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';

/// Alert card for the order awaiting dealer validation, with a live
/// countdown before the acceptance window closes (§4.3 / §6.5).
class PendingOrderCard extends StatefulWidget {
  const PendingOrderCard({
    super.key,
    required this.order,
    required this.onViewOrder,
  });

  final PendingOrder order;
  final VoidCallback onViewOrder;

  @override
  State<PendingOrderCard> createState() => _PendingOrderCardState();
}

class _PendingOrderCardState extends State<PendingOrderCard> {
  late Duration _remaining = widget.order.expiresIn;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    if (_remaining.inSeconds <= 0) {
      timer.cancel();
      return;
    }
    setState(() => _remaining -= const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _formattedRemaining {
    final minutes = _remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(Sizes.p16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(Sizes.p8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.schedule, color: AppColors.primary),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1 commande à valider', style: textTheme.labelLarge),
                    gapH4,
                    Text(
                      '#${widget.order.orderNumber} · ${CurrencyFormatter.formatUsd(widget.order.amount)}',
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
                    'Expire dans',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    _formattedRemaining,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          gapH16,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onViewOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Voir la commande',
                style: Theme.of(context).textTheme.bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
