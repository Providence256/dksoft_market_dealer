import 'package:dksoft_market_dealer/application_screen.dart';
import 'package:dksoft_market_dealer/features/address/presentation/address_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/login_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/signup_screen.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/widgets/role_guard.dart';
import 'package:dksoft_market_dealer/features/catalog/presentation/catalog_screen.dart';
import 'package:dksoft_market_dealer/features/orders/presentation/order_details_screen.dart';
import 'package:dksoft_market_dealer/features/orders/presentation/orders_screen.dart';
import 'package:dksoft_market_dealer/features/dashboard/presentation/dashboard_screen.dart';
import 'package:dksoft_market_dealer/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dksoft_market_dealer/features/profile/profile_screen.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:dksoft_market_dealer/features/provision/presentation/provision_request_screen.dart';
import 'package:dksoft_market_dealer/features/wallet/wallet_screen.dart';
import 'package:dksoft_market_dealer/routing/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  onboarding,
  dashboard,
  provisionRequest,
  catalog,
  commandes,
  orderDetails,
  wallet,
  profile,
  login,
  signup,
  address,
}

const _publicPaths = ['/', '/login', '/signup'];

final _rootNavigation = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigation,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.matchedLocation;
      final isPublic = _publicPaths.contains(path);

      if (!isLoggedIn && !isPublic) {
        return Uri(
          path: '/login',
          queryParameters: {'from': state.uri.toString()},
        ).toString();
      }

      // Only /login auto-redirects once signed in — this is what races
      // against manual post-sign-in navigation, so LoginScreen doesn't
      // navigate itself and lets this be the single source of truth.
      // /signup is deliberately excluded: a brand-new dealer must reach
      // /address first, and that redirect happens explicitly in
      // SignUpScreen once sign-up (including its Firestore writes)
      // fully completes, not the instant Firebase Auth reports a user.
      if (isLoggedIn && path == '/login') {
        final from = state.uri.queryParameters['from'];
        return (from != null && from.isNotEmpty)
            ? Uri.decodeComponent(from)
            : '/dashboard';
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
      GoRoute(
        path: '/address',
        name: AppRoute.address.name,
        builder: (context, state) => const AddressScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RoleGuard(
          child: ApplicationScreen(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: AppRoute.dashboard.name,
                builder: (context, state) => DashboardScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigation,
                    path: 'provision-request',
                    name: AppRoute.provisionRequest.name,
                    pageBuilder: (context, state) {
                      final type = state.extra as ProvisionRequestType;
                      return MaterialPage(
                        fullscreenDialog: true,
                        child: ProvisionRequestScreen(type: type),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigation,
                    path: 'catalog',
                    name: AppRoute.catalog.name,
                    builder: (context, state) => CatalogScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/commandes',
                name: AppRoute.commandes.name,
                builder: (context, state) => OrdersScreen(),
                routes: [
                  GoRoute(
                    path: ':orderId',
                    name: AppRoute.orderDetails.name,
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderDetailsScreen(orderId: orderId);
                    },
                  ),
                ],
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
