import 'package:dksoft_market_dealer/core/presentation/seed_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: kDebugMode
            ? ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SeedScreen()),
                ),
                child: const Text('Debug : Seed Firestore'),
              )
            : const Text('Profile'),
      ),
    );
  }
}
