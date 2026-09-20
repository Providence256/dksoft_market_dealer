import 'package:dksoft_market_dealer/features/authentication/application/is_dealer_provider.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wraps the dealer shell so only accounts carrying the `dealer` custom
/// claim can reach it. A client account that ends up here (shared auth
/// flow, wrong app) sees an explanation instead of dealer data, and can
/// sign back out.
class RoleGuard extends ConsumerWidget {
  const RoleGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDealerAsync = ref.watch(currentUserIsDealerProvider);

    return isDealerAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          _AccessMessage(title: 'Une erreur est survenue', message: '$error'),
      data: (isDealer) {
        if (isDealer) return child;
        return const _AccessMessage(
          title: 'Application réservée aux dealers',
          message:
              'Ce compte est enregistré comme client. Téléchargez l\'application '
              'Dksoft Market pour vos achats, ou connectez-vous avec un compte '
              'dealer.',
        );
      },
    );
  }
}

class _AccessMessage extends ConsumerWidget {
  const _AccessMessage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(Sizes.p20),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.block, color: AppColors.error, size: 40),
                ),
                gapH12,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                Text(
                  message,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                gapH16,
                ElevatedButton(
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: Text(
                    'Se déconnecter',
                    style: Theme.of(context).textTheme.bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
