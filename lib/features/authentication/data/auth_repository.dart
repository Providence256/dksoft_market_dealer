import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/app_user.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/firebase_app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static String usersPath() => 'users';

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  Stream<List<AppUser>> users() {
    return _auth.userChanges().map(
      (user) => user != null ? [FirebaseAppUser(user)] : [],
    );
  }

  String _pseudoEmailFor(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return '$digits@dksoft-market.app';
  }

  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: _pseudoEmailFor(phone),
      password: password,
    );
  }

  Future<void> signUpWithPhoneAndPassword({
    required String fullName,
    required String phone,
    required String password,
    required String commune,
    String? address,
    String? email,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: _pseudoEmailFor(phone),
      password: password,
    );

    final user = credential.user;
    if (user == null) return;

    await user.updateDisplayName(fullName);

    await _firestore.collection(usersPath()).doc(user.uid).set({
      'fullName': fullName,
      'phone': phone,
      'contactEmail': email,
      'commune': commune,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() => _auth.signOut();

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

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  AppUser? _convertUser(User? user) =>
      user != null ? FirebaseAppUser(user) : null;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
}

@Riverpod()
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
