import 'package:dksoft_market_dealer/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/user_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._authRepository) : super(const AsyncData(null));

  final AuthRepository _authRepository;

  Future<bool> signIn({required String phone, required String password}) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signInWithPhoneAndPassword(
        phone: phone,
        password: password,
      );
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
    required String commune,
    required UserRole role,
    String? email,
  }) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signUpWithPhoneAndPassword(
        fullName: fullName,
        phone: phone,
        password: password,
        commune: commune,
        role: role,
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
