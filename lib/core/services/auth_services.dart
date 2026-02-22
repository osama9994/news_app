
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/core/services/firebase_services.dart';

abstract class AuthServices {
  Future<bool> loginWithEmailAndPassowrd(String email, String password);
  Future<bool> registerWithEmailAndPassowrd(
    String email,
    String password,
    String username,
  );
  Future<bool> authenticateWithGoogle();
  User? currentUser();
  Future<void> logout();
}

class AuthServicesImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreServices _firestore = FirestoreServices.instance;

  /// LOGIN
  @override
  Future<bool> loginWithEmailAndPassowrd(
    String email,
    String password,
  ) async {
    final userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user != null;
  }

  /// REGISTER + USERNAME
  @override
  Future<bool> registerWithEmailAndPassowrd(
    String email,
    String password,
    String username,
  ) async {
    final userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) return false;

    /// 🔥 استخدام FirestoreServices
    await _firestore.setData(
      path: 'users/${user.uid}',
      data: {
        'uid': user.uid,
        'email': email,
        'username': username,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

    return true;
  }

  /// CURRENT USER
  @override
  User? currentUser() => _firebaseAuth.currentUser;

  /// LOGOUT
  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  /// GOOGLE AUTH + CREATE USER DOC IF NOT EXISTS
  @override
  Future<bool> authenticateWithGoogle() async {
    final gUser = await GoogleSignIn().signIn();
    if (gUser == null) return false;

    final gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) return false;

    /// 👇 تحقق هل المستخدم موجود في Firestore
    // ignore: unused_local_variable
    final existingUser = await _firestore.getDocument(
      path: 'users/${user.uid}',
      builder: (data, id) => data,
    );

    return true;
  }
}
