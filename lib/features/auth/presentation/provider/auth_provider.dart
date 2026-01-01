import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter/widgets.dart';

class AuthProviderr with ChangeNotifier {
  final SignUpUseCase signUp;
  final SignInUseCase signIn;
  final ResetPasswordUseCase resetPassword;

  bool isLoading = false;
  String? error;

  AuthProviderr({
    required this.signUp,
    required this.signIn,
    required this.resetPassword,
  });

  Future<bool> logIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await signIn(email, password);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await signUp(email, password);
      error = null;
      notifyListeners();
      return true;
      
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPasswordLink(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await resetPassword(email);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
