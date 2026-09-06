import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServices {
  Future<User?> registerWithEmailAndPassowrd(String email, String password);
  Future<bool> loginWithEmailAndPassowrd(String email, String password);
  Future<bool> authenticateWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> changePassword(String newPassword);
  User? currentUser();
  Future<void> logout();
}

class AuthServicesImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> registerWithEmailAndPassowrd(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<bool> loginWithEmailAndPassowrd(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user != null;
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    final gUser = await GoogleSignIn().signIn();
    if (gUser == null) return false;

    final gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user != null;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> changePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw FirebaseAuthException(
          code: 'no-user', message: 'No user is currently logged in.');
    }
  }

  @override
  User? currentUser() => _firebaseAuth.currentUser;

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}