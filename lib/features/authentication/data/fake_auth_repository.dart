import 'package:dksoft_market_dealer/features/authentication/domain/app_user.dart';
import 'package:dksoft_market_dealer/utils/validators/in_memory_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInwithNumberAndPassword(
    String phoneNumber,
    String password,
  ) async {
    if (currentUser == null) {
      _createNewUser(phoneNumber);
    }
  }

  Future<void> createUserWithPhoneNumberAndPassword({
    required String username,
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    if (currentUser == null) {
      _createNewUser(phoneNumber);
    }
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void _createNewUser(String phoneNumber) {
    _authState.value = AppUser(
      uid: phoneNumber.split('').reversed.join(),
      phoneNumber: phoneNumber,
    );
  }

  void dispose() => _authState.close();

  String mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'invalid-credential':
        case 'wrong-password':
          return 'Numéro de téléphone ou mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Un compte existe déjà avec ce numéro de téléphone.';
        case 'weak-password':
          return 'Le mot de passe doit contenir au moins 6 caractères.';
        case 'network-request-failed':
          return 'Vérifiez votre connexion internet et réessayez.';
        default:
          return 'Une erreur est survenue. Réessayez.';
      }
    }
    return 'Une erreur est survenue. Réessayez.';
  }
}

final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());

  return auth;
});

final fakeAuthStateChangeProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(fakeAuthRepositoryProvider);

  return authRepository.authStateChanges();
});
