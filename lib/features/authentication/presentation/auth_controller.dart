import 'package:dksoft_market_dealer/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._authRepository) : super(const AsyncData(null));

  final FakeAuthRepository _authRepository;

  Future<bool> signIn({required String phone, required String password}) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signInwithNumberAndPassword(phone, password);
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
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
      await _authRepository.createUserWithPhoneNumberAndPassword(
        username: fullName,
        phoneNumber: phone,
        password: password,
        email: email,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref.watch(fakeAuthRepositoryProvider));
    });
