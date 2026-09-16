import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Identity row at the top of the dashboard: avatar, name, verification
/// badge, commune and a notifications entry point.
class DealerDashboardHeader extends StatelessWidget {
  const DealerDashboardHeader({super.key, required this.dealer});

  final DealerProfile dealer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.secondaryLight.withValues(alpha: 0.25),
          child: Text(
            dealer.initials,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.secondaryDark,
            ),
          ),
        ),
        gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dealer.fullName, style: textTheme.headlineSmall),
              gapH4,
              Row(
                children: [
                  if (dealer.isVerified) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Vérifié',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    gapW8,
                  ],
                  Text(
                    dealer.commune,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.cardLight,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
