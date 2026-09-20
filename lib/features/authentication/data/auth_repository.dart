import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market_dealer/core/domain/dealer_model.dart';
import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';
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

    // This app only ever creates dealer accounts — every sign-up needs
    // admin validation before the dealer can treat orders (§6.2). The
    // `dealer` role itself is NOT written here: setDealerRoleClaim (Cloud
    // Function) sets it as a custom claim from the account's pseudo-email
    // domain. currentUserIsDealer() below reads that claim back.
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
    //
    // TODO(address): the sign-up form only collects a free-text address
    // today, but DealerModel.address needs a full PickupLocation (commune,
    // repère, lat/long) for the delivery-zone logic in §8. Placeholder
    // values are used below — either add those fields to the sign-up form,
    // or let the dealer complete this from their profile after admin
    // validation, and adjust this before shipping.
    final dealer = DealerModel(
      id: user.uid,
      fullName: fullName,
      phone: phone,
      email: email,
      address: PickupLocation(
        id: user.uid,
        name: fullName,
        address: address ?? '',
        commune: '',
        reference: '',
        latitude: 0,
        longitude: 0,
      ),
      provisionDisponible: 0,
      provisionBloquee: 0,
      provisonRetirable: 0,
      status: DealerStatus.enAttente,
      rating: 0,
    );

    batch.set(_firestore.collection(dealersPath()).doc(user.uid), {
      ...dealer.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Source of truth for "is this a dealer account" — reads the `role`
  /// custom claim set by the setDealerRoleClaim Cloud Function. Forces a
  /// token refresh so a claim set moments ago (e.g. right after sign-up)
  /// is visible immediately; Firebase otherwise caches the ID token.
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
