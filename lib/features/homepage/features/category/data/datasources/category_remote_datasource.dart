import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final String fieldName;

  CategoryRemoteDatasource(this.firestore, this.firebaseAuth, this.fieldName);

  Future<List<String>> fetchCategories() async {
    String userId = firebaseAuth.currentUser!.uid;
    final doc = await firestore.collection('users').doc(userId).get();

    // Create doc if not exists? Assuming it exists or check.
    // Ideally user doc exists.
    if (!doc.exists) return [];

    return List<String>.from(doc.data()?[fieldName] ?? []);
  }

  Future<void> addCategory(String label) async {
    String userId = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(userId).update({
      fieldName: FieldValue.arrayUnion([label]),
    });
  }

  Future<void> deleteCategory(String label) async {
    String userId = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(userId).update({
      fieldName: FieldValue.arrayRemove([label]),
    });
  }

  Future<bool> isCategoryDuplicated(String label) async {
    final response = await firestore
        .collection('users')
        .where(fieldName, arrayContains: label)
        .get();
    return response.docs.isNotEmpty;
  }
}
