import '../../data/datasources/profile_remote_data_sources.dart';
import '../../data/models/user_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRemoteDataSourceImpl remote;

  UserProfileModel? profile;
  bool isLoading = false;
  String? error;

  ProfileProvider(this.remote);

  Future<void> createProfile(UserProfileModel profileData) async {
    isLoading = true;
    notifyListeners();

    try {
      await remote.createProfile(profileData);
      profile = profileData;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
