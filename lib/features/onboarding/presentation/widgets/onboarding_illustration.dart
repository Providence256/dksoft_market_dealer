import 'package:dksoft_market_dealer/features/onboarding/domain/entities/onboarding_page_content.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Maps the UI-agnostic [OnboardingIcon] to a concrete Material icon.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.icon});

  final OnboardingIcon icon;

  IconData get _iconData => switch (icon) {
    OnboardingIcon.catalog => Icons.storefront_outlined,
    OnboardingIcon.provision => Icons.account_balance_wallet_outlined,
    OnboardingIcon.delivery => Icons.two_wheeler_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(_iconData, size: 72, color: AppColors.primary),
    );
  }
}
