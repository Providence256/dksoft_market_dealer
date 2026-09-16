import 'package:dksoft_market_dealer/features/onboarding/domain/entities/onboarding_page_content.dart';
import 'package:dksoft_market_dealer/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Onboarding copy is fixed content today. A future version could localise
/// it or A/B test it from a remote config source behind the same contract.
class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingPageContent> getPages() {
    return const [
      OnboardingPageContent(
        icon: OnboardingIcon.catalog,
        title: 'Proposez les meilleurs produits',
        description:
            'Parcourez les produits des commerçants partenaires et sélectionnez ceux que vous voulez vendre à vos clients.',
      ),
      OnboardingPageContent(
        icon: OnboardingIcon.provision,
        title: 'Gérez votre provision',
        description:
            'Alimentez votre provision pour valider vos commandes en toute sécurité et suivez vos gains en temps réel.',
      ),
      OnboardingPageContent(
        icon: OnboardingIcon.delivery,
        title: 'Livraison assurée par nos motards',
        description:
            "Dès qu'une commande est validée, un motard est affecté pour la récupérer et la livrer partout à Kinshasa.",
      ),
    ];
  }
}
