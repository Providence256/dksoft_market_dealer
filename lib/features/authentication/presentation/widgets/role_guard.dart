import 'package:dksoft_market_dealer/features/authentication/application/current_user_role_provider.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/user_role.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wraps the dealer shell so only accounts created with the `dealer` role
/// can reach it. A client account that ends up here (shared auth flow,
/// wrong app) sees an explanation instead of dealer data, and can sign
/// back out.
class RoleGuard extends ConsumerWidget {
  const RoleGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentUserRoleProvider);

    return roleAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          _AccessMessage(title: 'Une erreur est survenue', message: '$error'),
      data: (role) {
        if (role == UserRole.dealer) return child;
        return const _AccessMessage(
          title: 'Application réservée aux dealers',
          message:
              'Ce compte est enregistré comme client. Téléchargez l’application '
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
                Icon(Icons.block, color: AppColors.error, size: 40),
                gapH12,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                gapH16,
                OutlinedButton(
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  child: const Text('Se déconnecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
