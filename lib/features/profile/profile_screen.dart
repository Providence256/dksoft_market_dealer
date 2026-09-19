import 'package:dksoft_market_dealer/core/presentation/seed_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: kDebugMode
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SeedScreen()),
                    ),
                    child: const Text('Debug : Seed Firestore'),
                  ),
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
              )
            : const Text('Profile'),
      ),
    );
  }
}
