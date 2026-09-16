import 'package:dksoft_market_dealer/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:dksoft_market_dealer/features/onboarding/domain/entities/onboarding_page_content.dart';
import 'package:dksoft_market_dealer/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(),
);

final onboardingPagesProvider = Provider<List<OnboardingPageContent>>(
  (ref) => ref.watch(onboardingRepositoryProvider).getPages(),
);

/// Tracks which onboarding page is currently visible so the presentation
/// layer (page indicator, "Suivant"/"Commencer" button) can react to it.
class OnboardingPageIndexController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final onboardingPageIndexProvider =
    NotifierProvider<OnboardingPageIndexController, int>(
      OnboardingPageIndexController.new,
    );
