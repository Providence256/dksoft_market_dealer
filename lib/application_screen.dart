import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ApplicationScreen extends ConsumerWidget {
  const ApplicationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  )
                : TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          indicatorColor: Theme.of(context).colorScheme.primary
              .withValues(alpha: 0.2),
          destinations: [
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedDashboardCircleAdd),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardCircleAdd,
              ),
              label: 'Bord',
            ),

            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedInvoice01),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedInvoice01),
              label: 'Commandes',
            ),

            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedWallet02),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedWallet02),
              label: 'Portefeuille',
            ),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
