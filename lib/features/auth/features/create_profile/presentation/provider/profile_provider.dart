import '../../data/datasources/profile_remote_data_sources.dart';
import '../../data/models/user_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRemoteDataSourceImpl remote;

  UserProfileModel? profile;
  bool isLoading = false;
  String? error;

  ProfileProvider(this.remote);

  Future<bool> createProfile(UserProfileModel profileData) async {
    isLoading = true;
    error = null;
    notifyListeners();
    bool success = false;

    try {
      await remote.createProfile(profileData);
      profile = profileData;
      success = true;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
    return success;
  }
}
