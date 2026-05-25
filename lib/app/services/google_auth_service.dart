import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (kIsWeb || _initialized) return;
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  static Future<UserCredential> signIn() async {
    if (kIsWeb) {
      return FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    }

    await ensureInitialized();
    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-google-id-token',
        message: 'Google tidak mengembalikan ID token.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> signOut() async {
    if (!kIsWeb) {
      await ensureInitialized();
      await GoogleSignIn.instance.signOut();
    }
    await FirebaseAuth.instance.signOut();
  }
}
