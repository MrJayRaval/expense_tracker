import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> fetchUserData();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Map<String, dynamic>> fetchUserData() async {
    String uid = firebaseAuth.currentUser!.uid;
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data();

    return {'name': data!['name'], 'email': data['email']};
  }
}
