// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:news_app/core/models/user_data.dart';
// import 'package:news_app/core/services/auth_services.dart';
// import 'package:news_app/core/services/firebase_services.dart';
// import 'package:news_app/core/utils/api_pathes.dart';

// part 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(AuthInitial());

//   final AuthServices _authServices = AuthServicesImpl();
//   final FirestoreServices _firestore = FirestoreServices.instance;

//   // =========================
//   // SAVE USER DATA
//   // =========================
//   Future<void> _saveUserData(User user, String email) async {
//     final userData = UserData(
//       id: user.uid,
//       email: email,
//       createdAt: DateTime.now(),
//     );

//     await _firestore.setData(
//       path: ApiPaths.users(user.uid),
//       data: userData.toMap(),
//     );
//   }

//   // =========================
//   // REGISTER
//   // =========================
//  Future<void> registerWithEmailAndPassword({
//   required String email,
//   required String password,
// }) async {
//   emit(AuthLoading());

//   try {
//     final User? user = await _authServices.registerWithEmailAndPassowrd(
//       email,
//       password,
//     );

//     if (user == null) {
//       emit(AuthError('Registration failed'));
//       return;
//     }

//     // Navigate immediately
//     emit(const AuthDone());

//     // Save user data in background (don’t block UI)
//     _saveUserData(user, email).catchError((e) {
//       // Optional: log or handle Firestore error
//     });
//   } catch (e) {
//     emit(AuthError(e.toString()));
//   }
// }
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
//           await _authServices.loginWithEmailAndPassowrd(email, password);

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
//   // GOOGLE SIGN IN
//   // =========================
//   Future<void> signInWithGoogle() async {
//     emit(const GoogleAuthenticating());

//     try {
//       final bool result = await _authServices.authenticateWithGoogle();

//       if (result) {
//         emit(const GoogleAuthDone());
//       } else {
//         emit(GoogleAuthError('Google sign-in failed'));
//       }
//     } catch (e) {
//       emit(GoogleAuthError(e.toString()));
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
//   // CURRENT USER
//   // =========================
//   User? currentUser() => _authServices.currentUser();
  
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

//   // =========================
//   // reset Password
//   // =========================
// Future<void> resetPassword({required String email}) async {
//   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// }
// }


// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/user_data.dart';
import 'package:news_app/core/services/auth_services.dart';
import 'package:news_app/core/services/firebase_services.dart';
import 'package:news_app/core/utils/api_pathes.dart';
import 'package:news_app/core/utils/app_constants.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices _authServices = AuthServicesImpl();
  final FirestoreServices _firestore = FirestoreServices.instance;

  // =========================
  // SAVE USER DATA
  // =========================
  // Future<void> _saveUserData(User user, String email) async {
  //   // ✅ جلب FCM Token
  //   final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

  //   final userData = UserData(
  //     id: user.uid,
  //     email: email,
  //     createdAt: DateTime.now(),
  //     fcmToken: fcmToken,
  //     favoriteCategories: const [],
  //     isOnboardingDone: false,
  //   );

  //   await _firestore.setData(
  //     path: ApiPaths.users(user.uid),
  //     data: userData.toMap(),
  //   );
  // }
Future<void> _saveUserData(User user, String email) async {
  try {
    // ignore: duplicate_ignore
    // ignore: avoid_print
    print("⏳ Saving user data...");
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    print("✅ FCM Token: $fcmToken");

    final userData = UserData(
      id: user.uid,
      email: email,
      createdAt: DateTime.now(),
      fcmToken: fcmToken,
      favoriteCategories: const [],
      isOnboardingDone: false,
    );

    await _firestore.setData(
      path: ApiPaths.users(user.uid),
      data: userData.toMap(),
    );
    // ignore: duplicate_ignore
    // ignore: avoid_print
    print("✅ Firestore save done!");

  } catch (e) {
    // ignore: duplicate_ignore
    // ignore: avoid_print
    print("❌ _saveUserData error: $e"); // 👈 هنا ستظهر المشكلة
    rethrow;
  }
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

      // ✅ انتظر حفظ البيانات أولاً
      await _saveUserData(user, email);

      // ✅ بعدها انتقل لشاشة الفئات
      emit(const AuthDone());

    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // =========================
  // SAVE USER CATEGORIES (بعد الـ Onboarding)
  // =========================
  Future<void> saveUserCategories({
    required List<String> categories,
  }) async {
    emit(CategoriesSaving());

    try {
      final user = _authServices.currentUser();
      if (user == null) {
        emit(CategoriesError('No user logged in'));
        return;
      }

      // ✅ اشترك في FCM Topics
      for (final category in categories) {
        await FirebaseMessaging.instance.subscribeToTopic(category);
      }

      // ✅ حفظ في Firestore
      await _firestore.setData(
        path: ApiPaths.users(user.uid),
        data: {
          'favoriteCategories': categories,
          'isOnboardingDone': true,
        },
      );

      // ✅ حفظ في Hive محلياً
      final box = Hive.box(AppConstants.localDatabaseBox);
      await box.put('favoriteCategories', categories);
      await box.put('isOnboardingDone', true);

      emit(const CategoriesSaved());

    } catch (e) {
      emit(CategoriesError(e.toString()));
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
      // ✅ إلغاء اشتراك FCM Topics عند تسجيل الخروج
      final box = Hive.box(AppConstants.localDatabaseBox);
      final categories = box.get('favoriteCategories');
      if (categories != null) {
        for (final category in (categories as List)) {
          await FirebaseMessaging.instance.unsubscribeFromTopic(category);
        }
      }

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
  // CHANGE PASSWORD
  // =========================
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordLoading());

    try {
      final user = _authServices.currentUser();
      if (user == null) {
        emit(const ChangePasswordError("No user logged in."));
        return;
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      emit(const ChangePasswordSuccess("Password changed successfully."));
    } on FirebaseAuthException catch (e) {
      emit(ChangePasswordError(e.message ?? "Failed to change password."));
    } catch (e) {
      emit(ChangePasswordError("An unexpected error occurred."));
    }
  }

  // =========================
  // RESET PASSWORD
  // =========================
  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
