import 'package:dksoft_market_dealer/features/dashboard/domain/entities/dealer_profile.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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
              Row(
                children: [
                  Text(dealer.fullName, style: textTheme.headlineSmall),
                  gapW4,
                  if (dealer.isVerified) ...[
                    Icon(Icons.verified, size: 14, color: Colors.blue),
                  ],
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
