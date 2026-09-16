import 'package:dksoft_market_dealer/application_screen.dart';
import 'package:dksoft_market_dealer/features/commandes/commandes_screen.dart';
import 'package:dksoft_market_dealer/features/dashboard/dashboard_screen.dart';
import 'package:dksoft_market_dealer/features/profile/profile_screen.dart';
import 'package:dksoft_market_dealer/features/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRouter { dashboard, commandes, wallet, profile }

final _rootNavigation = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ApplicationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: AppRouter.dashboard.name,
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/commandes',
                name: AppRouter.commandes.name,
                builder: (context, state) => CommandesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                name: AppRouter.wallet.name,
                builder: (context, state) => WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRouter.profile.name,
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
