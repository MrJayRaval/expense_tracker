import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/History/domain/datasource/history_remote_datasource.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryRemoteDatasourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  HistoryRemoteDatasourceImpl({required this.firestore, required this.auth});

  @override
  Future<List<IncomeDetailsModel>> fetchIncomeHistory() async {
    String uid = auth.currentUser!.uid;
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('income')
        .orderBy('TimeStamp', descending: true)
        .get();

    return snapshot.docs
        .map((e) => IncomeDetailsModel.fromJson(e.data(), e.id))
        .toList();
  }
  
  @override
  Future<void> deleteParticularIncome(String id) async{
    String uid = auth.currentUser!.uid;
    await firestore.collection('users').doc(uid).collection('income').doc(id).delete();

  }
}
