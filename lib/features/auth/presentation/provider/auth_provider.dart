import '../../domain/usecases/reset_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthProvider with ChangeNotifier {
  final SignUpUseCase signUp;
  final SignInUseCase signIn;
  final ResetPasswordUseCase resetPassword;

  bool isLoading = false;
  String? error;

  AuthProvider({
    required this.signUp,
    required this.signIn,
    required this.resetPassword,
  });

  void clearError() {
    error = null;
    notifyListeners();
  }

  String _friendlyMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Email address is invalid.';
        default:
          return error.message ?? 'Authentication failed.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  Future<bool> logIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    bool success = false;

    try {
      await signIn(email, password);
      success = true;
    } catch (e) {
      error = _friendlyMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }

  Future<bool> register(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    bool success = false;

    try {
      await signUp(email, password);
      success = true;
    } catch (e) {
      error = _friendlyMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }

  Future<bool> resetPasswordLink(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();
    bool success = false;

    try {
      await resetPassword(email);
      success = true;
    } catch (e) {
      error = _friendlyMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }
}
