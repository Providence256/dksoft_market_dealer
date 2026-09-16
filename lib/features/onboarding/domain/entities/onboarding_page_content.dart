/// Static content for one page of the dealer onboarding carousel.
class OnboardingPageContent {
  const OnboardingPageContent({
    required this.icon,
    required this.title,
    required this.description,
  });

  final OnboardingIcon icon;
  final String title;
  final String description;
}

/// Abstracts the illustration choice away from any UI/icon package, so the
/// domain layer stays free of Flutter dependencies. The presentation layer
/// maps each value to a concrete icon.
enum OnboardingIcon { catalog, provision, delivery }
