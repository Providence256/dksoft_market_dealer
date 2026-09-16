import 'package:dksoft_market_dealer/features/onboarding/domain/entities/onboarding_page_content.dart';

abstract class OnboardingRepository {
  List<OnboardingPageContent> getPages();
}
