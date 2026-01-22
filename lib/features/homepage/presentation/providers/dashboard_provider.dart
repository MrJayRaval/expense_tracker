import 'package:expense_tracker/features/homepage/domain/usecases/fetch_user_details_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  final FetchUserDetailsUsecase fetchUserDetailsUsecase;

  bool isLoading = false;
  String? error;

  DashboardProvider({required this.fetchUserDetailsUsecase});

  Map<String, dynamic>? user;

  Future<void> fetchUserDetails() async {
    isLoading = true;
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      user =await  fetchUserDetailsUsecase(uid);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
