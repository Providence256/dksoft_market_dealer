import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._authRepository) : super(const AsyncData(null));

  final AuthRepository _authRepository;

  /// This app is dealer-only: anyone whose account isn't tagged with the
  /// `dealer` custom claim (i.e. wasn't created through this app's
  /// sign-up) is signed back out immediately, with a clear message,
  /// instead of being allowed in and blocked later by RoleGuard.
  Future<bool> signIn({required String phone, required String password}) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signInWithPhoneAndPassword(
        phone: phone,
        password: password,
      );

      final isDealer = await _authRepository.currentUserIsDealer();
      if (!isDealer) {
        await _authRepository.signOut();
        state = AsyncError(
          "Ce compte n'est pas un compte dealer. Utilisez l'application "
          'Dksoft Market pour vos achats.',
          StackTrace.current,
        );
        return false;
      }

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(_authRepository.mapAuthError(error), stackTrace);
      return false;
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  }) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signUpWithPhoneAndPassword(
        fullName: fullName,
        phone: phone,
        password: password,
        email: email,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(_authRepository.mapAuthError(error), stackTrace);
      return false;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });
