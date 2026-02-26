import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/models/user_data.dart';
import 'package:news_app/core/services/auth_services.dart';
import 'package:news_app/core/services/firebase_services.dart';
import 'package:news_app/core/utils/api_pathes.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices _authServices = AuthServicesImpl();
  final FirestoreServices _firestore = FirestoreServices.instance;

  // =========================
  // SAVE USER DATA
  // =========================
  Future<void> _saveUserData(User user, String email) async {
    final userData = UserData(
      id: user.uid,
      email: email,
      createdAt: DateTime.now(),
    );

    await _firestore.setData(
      path: ApiPaths.users(user.uid),
      data: userData.toMap(),
    );
  }

  // =========================
  // REGISTER
  // =========================
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final User? user = await _authServices.registerWithEmailAndPassowrd(
        email,
        password,
      );

      if (user == null) {
        emit(AuthError('Registration failed'));
        return;
      }

      await _saveUserData(user, email);

      emit(const AuthDone());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final bool result =
          await _authServices.loginWithEmailAndPassowrd(email, password);

      if (result) {
        emit(const AuthDone());
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // =========================
  // GOOGLE SIGN IN
  // =========================
  Future<void> signInWithGoogle() async {
    emit(const GoogleAuthenticating());

    try {
      final bool result = await _authServices.authenticateWithGoogle();

      if (result) {
        emit(const GoogleAuthDone());
      } else {
        emit(GoogleAuthError('Google sign-in failed'));
      }
    } catch (e) {
      emit(GoogleAuthError(e.toString()));
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    emit(AuthLogingOut());

    try {
      await _authServices.logout();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthLogOutError(e.toString()));
    }
  }

  // =========================
  // CURRENT USER
  // =========================
  User? currentUser() => _authServices.currentUser();
  
  // =========================
  // Change password
  // =========================

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  emit(const ChangePasswordLoading());

  try {
    final user = _authServices.currentUser(); // استخدم دالتك الحالية لإرجاع المستخدم
    if (user == null) {
      emit(const ChangePasswordError("No user logged in."));
      return;
    }

    // إعادة التحقق من المستخدم باستخدام كلمة المرور الحالية
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);

    // تغيير كلمة المرور
    await user.updatePassword(newPassword);

    emit(const ChangePasswordSuccess("Password changed successfully."));
  } on FirebaseAuthException catch (e) {
    emit(ChangePasswordError(e.message ?? "Failed to change password."));
  } catch (e) {
    emit(ChangePasswordError("An unexpected error occurred."));
  }
}

  // =========================
  // reset Password
  // =========================
Future<void> resetPassword({required String email}) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/models/user_data.dart';
// import 'package:news_app/core/services/auth_services.dart';
// import 'package:news_app/core/services/firebase_services.dart';
// import 'package:news_app/core/utils/api_pathes.dart';
// part 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(AuthInitial());

//   final AuthServices _authServices = AuthServicesImpl();
//   final FirestoreServices _firestoreServices =
//       FirestoreServices.instance;

//   // =========================
//   // SAVE USER DATA (Firestore)
//   // =========================
//   Future<void> _saveUserData({
//     required String email,
//     // required String username,
//   }) async {
//     final user = _authServices.currentUser();

//     if (user == null) {
//       throw Exception('User not found');
//     }

//     final userData = UserData(
//       id: user.uid,
//       email: email,
//       // username: username,
//       createdAt: DateTime.now(),
//     );

//     await _firestoreServices.setData(
//       path: ApiPaths.users(user.uid),
//       data: userData.toMap(),
//     );
//   }

//   // =========================
//   // REGISTER
 
//   Future<void> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//     // required String username,
//   }) async {
//     emit(AuthLoading());

//     try {
//       final bool result =
//           await _authServices.registerWithEmailAndPassowrd(
//         email,
//         password,
//         // username,
//       );

//       if (!result) {
//         emit(AuthError('Registration failed'));
//         return;
//       }

//       await _saveUserData(
//         email: email,
//         // username: username,
//       );

//       emit(const AuthDone());
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   // =========================
//   // LOGIN
//   // =========================
//   Future<void> loginWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     emit(AuthLoading());

//     try {
//       final bool result =
//           await _authServices.loginWithEmailAndPassowrd(
//         email,
//         password,
//       );

//       if (result) {
//         emit(const AuthDone());
//       } else {
//         emit(AuthError('Login failed'));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }


//   // =========================
//   // CHECK AUTH STATE
//   // =========================
//   void checkAuth() {
//     final user = _authServices.currentUser();
//     if (user != null) {
//       emit(const AuthDone());
//     } else {
//       emit(AuthInitial());
//     }
//   }

//   // =========================
//   // LOGOUT
//   // =========================
//   Future<void> logout() async {
//     emit(AuthLogingOut());

//     try {
//       await _authServices.logout();
//       emit(const AuthLoggedOut());
//     } catch (e) {
//       emit(AuthLogOutError(e.toString()));
//     }
//   }

//   // =========================
//   // GOOGLE SIGN IN
//   // =========================
//   Future<void> signInWithGoogle() async {
//     emit(const GoogleAuthenticating());

//     try {
//       final bool result =
//           await _authServices.authenticateWithGoogle();

//       if (!result) {
//         emit(GoogleAuthError('Google sign-in failed'));
//         return;
//       }

//       // OPTIONAL:
//       // يمكنك هنا التحقق هل المستخدم موجود في Firestore أم لا
//       emit(const GoogleAuthDone());
//     } catch (e) {
//       emit(GoogleAuthError(e.toString()));
//     }
//   }

//   // =========================
//   // Change password
//   // =========================

// Future<void> changePassword({
//   required String currentPassword,
//   required String newPassword,
// }) async {
//   emit(const ChangePasswordLoading());

//   try {
//     final user = _authServices.currentUser(); // استخدم دالتك الحالية لإرجاع المستخدم
//     if (user == null) {
//       emit(const ChangePasswordError("No user logged in."));
//       return;
//     }

//     // إعادة التحقق من المستخدم باستخدام كلمة المرور الحالية
//     final cred = EmailAuthProvider.credential(
//       email: user.email!,
//       password: currentPassword,
//     );
//     await user.reauthenticateWithCredential(cred);

//     // تغيير كلمة المرور
//     await user.updatePassword(newPassword);

//     emit(const ChangePasswordSuccess("Password changed successfully."));
//   } on FirebaseAuthException catch (e) {
//     emit(ChangePasswordError(e.message ?? "Failed to change password."));
//   } catch (e) {
//     emit(ChangePasswordError("An unexpected error occurred."));
//   }
// }
// User? currentUser() {
//   return FirebaseAuth.instance.currentUser;
// }
//   // =========================
//   // reset Password
//   // =========================
// Future<void> resetPassword({required String email}) async {
//   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// }


// }


