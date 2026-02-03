import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CategoryRemoteDatasource(this.firestore, this.firebaseAuth);

  Future<List<String>> fetchCategories() async {
    String userId = firebaseAuth.currentUser!.uid;
    final doc = await firestore.collection('users').doc(userId).get();

    return List<String>.from(doc['categories'] ?? []);
  }

  Future<void> addCategory(String label) async {
    String userId = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(userId).update({
      'categories': FieldValue.arrayUnion([label]),
    });
  }

  Future<void> deleteCategory(String label) async {
    String userId = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(userId).update({
      'categories': FieldValue.arrayRemove([label]),
    });
  }

  Future<bool> isCategoryDuplicated(String label) async {
    final response = await firestore
        .collection('users')
        .where('categories', arrayContains: label)
        .get();
    return response.docs.isNotEmpty;
  }
}
