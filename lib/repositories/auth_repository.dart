import 'package:GetGroceries/general_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;

  Future<void> signInAnonymously();

  Future<void> signInWithGoogle();

  User? getCurrentUser();

  Future<void> signOut();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

final googleSignIn = GoogleSignIn(scopes: ['email']);

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  @override
  // TODO: implement authStateChanges
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    // TODO: implement signInAnonymously
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // TODO
      throw CustomException(message: e.message);
    }
  }

  @override
  User? getCurrentUser() {
    // TODO: implement getCurrentUser
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      // TODO
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    try {
      await _read(firebaseAuthProvider).signOut();
      await googleSignIn.signOut();
      // await signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      // TODO
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    // TODO: implement signInWithGoogle
    try {
      if(kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await _read(firebaseAuthProvider).signInWithPopup(googleProvider);
      }
      else {
        final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        await _read(firebaseAuthProvider).signInWithCredential(credential);
        print(googleUser.displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
