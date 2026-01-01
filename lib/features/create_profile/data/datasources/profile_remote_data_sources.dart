import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/create_profile/data/models/user_profile_model.dart';

class ProfileRemoteDataSourceImpl {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  Future<void> createProfile(UserProfileModel profile) async {
    await firestore.collection('users').doc(profile.uid).set(profile.toMap());
  }
}
