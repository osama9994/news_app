
// part of 'auth_cubit.dart';


// sealed class AuthState {
//   const AuthState();
// }

// final class AuthInitial extends AuthState {}
// final class AuthLoading extends AuthState {}
// final class AuthDone extends AuthState {
//   const AuthDone();
// }
// final class AuthError extends AuthState {
//   final String message;
//   AuthError(this.message);
// }

// final class AuthLoggedOut extends AuthState {
//   const AuthLoggedOut();
// }
// final class AuthLogingOut extends AuthState {
//   const AuthLogingOut();
// }
// final class AuthLogOutError extends AuthState {
//   final String message;
//   AuthLogOutError(this.message);

  
// }


// final class GoogleAuthenticating  extends AuthState {
  
// const GoogleAuthenticating();
  
// }

// final class GoogleAuthError extends AuthState {
//   final String message;
//   GoogleAuthError(this.message);
// }

// final class GoogleAuthDone extends AuthState{
//   const GoogleAuthDone();
// }

// final class ChangePasswordLoading extends AuthState {
//   const ChangePasswordLoading();
// }

// final class ChangePasswordSuccess extends AuthState {
//   final String message;
//   const ChangePasswordSuccess(this.message);
// }

// final class ChangePasswordError extends AuthState {
//   final String message;
//   const ChangePasswordError(this.message);
// }

part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}

final class AuthDone extends AuthState {
  const AuthDone();
}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
final class AuthLogingOut extends AuthState {}
final class AuthLogOutError extends AuthState {
  final String message;
  AuthLogOutError(this.message);
}

final class GoogleAuthenticating extends AuthState {
  const GoogleAuthenticating();
}
final class GoogleAuthError extends AuthState {
  final String message;
  GoogleAuthError(this.message);
}
final class GoogleAuthDone extends AuthState {
  const GoogleAuthDone();
}

final class ChangePasswordLoading extends AuthState {
  const ChangePasswordLoading();
}
final class ChangePasswordSuccess extends AuthState {
  final String message;
  const ChangePasswordSuccess(this.message);
}
final class ChangePasswordError extends AuthState {
  final String message;
  const ChangePasswordError(this.message);
}

// ✅ جديد - خاص بحفظ الفئات
final class CategoriesSaving extends AuthState {}
final class CategoriesSaved extends AuthState {
  const CategoriesSaved();
}
final class CategoriesError extends AuthState {
  final String message;
  CategoriesError(this.message);
}