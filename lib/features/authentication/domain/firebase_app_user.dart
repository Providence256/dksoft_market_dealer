import 'dart:convert';

import 'package:dksoft_market_dealer/features/authentication/domain/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAppUser implements AppUser {
  FirebaseAppUser(this._user);

  final User _user;

  @override
  String get uid => _user.uid;

  @override
  String? get username => _user.displayName;

  @override
  String? get email => _user.email;

  @override
  String? get phoneNumber => _user.phoneNumber;

  @override
  String? get profilePicture => _user.photoURL;

  @override
  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    String? phoneNumber,
    String? profilePicture,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toJson() {
    return json.encode(toMap());
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}
