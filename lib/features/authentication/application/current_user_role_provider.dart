import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/user_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves the Firestore-stored role of the signed-in user (null when
/// signed out). Rebuilds whenever the Firebase auth state changes —
/// login, logout, or switching accounts.
final currentUserRoleProvider = FutureProvider.autoDispose<UserRole?>((
  ref,
) async {
  final user = await ref.watch(authStateChangesProvider.future);
  if (user == null) return null;
  return ref.watch(authRepositoryProvider).fetchUserRole(user.uid);
});
