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

  Future<void> logIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await signIn(email, password);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    ChangeNotifier();
  }

  Future<void> register(String email, String password) async {
    isLoading = true;
    ChangeNotifier();

    try {
      await signUp(email, password);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    ChangeNotifier();
  }

  Future<void> resetPasswordLink(String email) async {
    isLoading = true;
    ChangeNotifier();

    try {
      await resetPassword(email);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    ChangeNotifier();
  }
}
