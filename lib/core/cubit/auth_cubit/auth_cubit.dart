import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _saveUserData(User user, String email) async {
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

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
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final user = await _authServices.registerWithEmailAndPassowrd(
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

      for (final category in categories) {
        await FirebaseMessaging.instance.subscribeToTopic(category);
      }

      await _firestore.setData(
        path: ApiPaths.users(user.uid),
        data: {
          'favoriteCategories': categories,
          'isOnboardingDone': true,
        },
      );

      final box = Hive.box(AppConstants.localDatabaseBox);
      await box.put('favoriteCategories', categories);
      await box.put('isOnboardingDone', true);

      emit(const CategoriesSaved());
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final result =
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

  Future<void> signInWithGoogle() async {
    emit(const GoogleAuthenticating());

    try {
      final result = await _authServices.authenticateWithGoogle();

      if (result) {
        emit(const GoogleAuthDone());
      } else {
        emit(GoogleAuthError('Google sign-in failed'));
      }
    } catch (e) {
      emit(GoogleAuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLogingOut());

    try {
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

  User? currentUser() => _authServices.currentUser();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordLoading());

    try {
      final user = _authServices.currentUser();
      if (user == null) {
        emit(const ChangePasswordError('No user logged in.'));
        return;
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      emit(const ChangePasswordSuccess('Password changed successfully.'));
    } on FirebaseAuthException catch (e) {
      emit(ChangePasswordError(e.message ?? 'Failed to change password.'));
    } catch (e) {
      emit(const ChangePasswordError('An unexpected error occurred.'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
