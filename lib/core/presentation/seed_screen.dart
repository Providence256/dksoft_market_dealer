import 'package:dksoft_market_dealer/core/presentation/seed_all_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug-only tool: pushes the fixture data (brands, categories,
/// merchants, dealer profiles, products + their images) into this
/// Firebase project so both apps read the same data. Never linked from
/// the main navigation — see [ProfileScreen]'s `kDebugMode`-gated entry.
class SeedScreen extends ConsumerWidget {
  const SeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(seedAllControllerProvider);
    final notifier = ref.read(seedAllControllerProvider.notifier);
    final isRunning =
        progressAsync.isLoading || progressAsync.valueOrNull?.step != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Seed Firestore (debug)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Envoie les données de test vers ce projet Firebase — images '
            'comprises — pour que Dksoft Market et Dksoft Market Dealer '
            'partagent les mêmes données.',
          ),
          const SizedBox(height: 20),
          _SeedButton(
            label: 'Marques',
            onPressed: isRunning ? null : notifier.seedBrands,
          ),
          _SeedButton(
            label: 'Catégories (avec images)',
            onPressed: isRunning ? null : notifier.seedCategories,
          ),
          _SeedButton(
            label: 'Marchands',
            onPressed: isRunning ? null : notifier.seedMerchants,
          ),
          _SeedButton(
            label: 'Profils dealer (annuaire de démo)',
            onPressed: isRunning ? null : notifier.seedDealerProfiles,
          ),
          _SeedButton(
            label: 'Produits (avec images)',
            onPressed: isRunning ? null : notifier.seedProducts,
          ),
          const Divider(height: 32),
          FilledButton(
            onPressed: isRunning ? null : notifier.seedAll,
            child: const Text('Tout seeder, dans le bon ordre'),
          ),
          const SizedBox(height: 24),
          progressAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Erreur: $error',
              style: const TextStyle(color: Colors.red),
            ),
            data: (progress) {
              if (progress.step == null) {
                return const Text('Prêt.');
              }
              final label = switch (progress.step!) {
                SeedStep.brands => 'Marques...',
                SeedStep.categories => 'Catégories...',
                SeedStep.merchants => 'Marchands...',
                SeedStep.dealerProfiles => 'Profils dealer...',
                SeedStep.products => progress.productsTotal == 0
                    ? 'Produits...'
                    : 'Produits : ${progress.productsDone}/${progress.productsTotal}',
              };
              return Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SeedButton extends StatelessWidget {
  const _SeedButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }
}
