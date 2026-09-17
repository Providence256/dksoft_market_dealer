import 'package:dksoft_market_dealer/application_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/data/fake_auth_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/login_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/signup_screen.dart';
import 'package:dksoft_market_dealer/features/commandes/commandes_screen.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/dashboard_screen.dart';
import 'package:dksoft_market_dealer/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dksoft_market_dealer/features/profile/profile_screen.dart';
import 'package:dksoft_market_dealer/features/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  onboarding,
  dashboard,
  commandes,
  wallet,
  profile,
  login,
  signup,
}

const _publicPaths = ['/', '/login', '/signup'];

final _rootNavigation = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(fakeAuthRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigation,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.matchedLocation;
      final isAuthRoute = path == '/login' || path == '/signup';
      final isPublic = _publicPaths.contains(path);

      if (!isLoggedIn && !isPublic) {
        return Uri(
          path: '/login',
          queryParameters: {'from': state.uri.toString()},
        ).toString();
      }

      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ApplicationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: AppRoute.dashboard.name,
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/commandes',
                name: AppRoute.commandes.name,
                builder: (context, state) => CommandesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                name: AppRoute.wallet.name,
                builder: (context, state) => WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
