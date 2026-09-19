import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/app_user.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/firebase_app_user.dart';
import 'package:dksoft_market_dealer/features/authentication/domain/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static String usersPath() => 'users';
  static String dealersPath() => 'dealers';

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

    // This app only ever creates dealer accounts — anyone signing up here
    // needs admin validation before they can treat orders (§6.2).
    final batch = _firestore.batch();

    batch.set(_firestore.collection(usersPath()).doc(user.uid), {
      'fullName': fullName,
      'phone': phone,
      'contactEmail': email,
      'address': address,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Seeds the provision wallet described in §5.5: nothing available,
    // nothing blocked, nothing to withdraw until the dealer is validated
    // and alimente sa provision.
    batch.set(_firestore.collection(dealersPath()).doc(user.uid), {
      'fullName': fullName,
      'isVerified': false,
      'provisionAvailable': 0,
      'provisionBlocked': 0,
      'withdrawable': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Reads back the role stored on `users/{uid}` at sign-up. Returns null
  /// if the profile doc doesn't exist yet (race with sign-up) or predates
  /// the role field.
  Future<UserRole?> fetchUserRole(String uid) async {
    final doc = await _firestore.collection(usersPath()).doc(uid).get();
    final raw = doc.data()?['role'] as String?;
    for (final role in UserRole.values) {
      if (role.name == raw) return role;
    }
    return null;
  }

  /// Source of truth for "is this a dealer account", read from the
  /// `role` custom claim the `setDealerRoleClaim` Cloud Function sets on
  /// accounts created with the dealer pseudo-email domain. Forces a token
  /// refresh so a claim set moments ago (e.g. right after sign-up) is
  /// visible immediately — Firebase caches the ID token otherwise.
  Future<bool> currentUserIsDealer() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    final tokenResult = await user.getIdTokenResult(true);
    return tokenResult.claims?['role'] == 'dealer';
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
