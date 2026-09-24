import 'package:dksoft_market_dealer/features/onboarding/application/onboarding_providers.dart';
import 'package:dksoft_market_dealer/features/onboarding/presentation/widgets/onboarding_illustration.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToDashboard(BuildContext context) {
    // No auth flow yet: the dealer lands directly on the dashboard.
    // TODO: route to login/register once the auth module is implemented.
    context.goNamed(AppRoute.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(onboardingPagesProvider);
    final currentIndex = ref.watch(onboardingPageIndexProvider);
    final isLastPage = currentIndex == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: TextButton(
                  onPressed: () => _goToDashboard(context),
                  child: const Text('Passer'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => ref
                    .read(onboardingPageIndexProvider.notifier)
                    .setIndex(index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardingIllustration(icon: page.icon),
                        gapH32,
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        gapH12,
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondaryLight,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == currentIndex ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? AppColors.secondary
                        : AppColors.dividerLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            gapH24,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      _goToDashboard(context);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(isLastPage ? 'Commencer' : 'Suivant'),
                ),
              ),
            ),
            gapH32,
          ],
        ),
      ),
    );
  }
}
