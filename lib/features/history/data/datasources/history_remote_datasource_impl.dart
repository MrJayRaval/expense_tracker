import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasource/history_remote_datasource.dart';
import '../../../income/domain/entity/income_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  Future<void> deleteParticularIncome(String id) async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection('users')
        .doc(uid)
        .collection('income')
        .doc(id)
        .delete();
  }

  @override
  Future<void> updateIncome(IncomeDetailsModel income) async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('income')
          .doc(income.id)
          .update({
            'IncomeType': income.incomeTypeLabel,
            'IncomeTypeIcon': income.incomeTypeIcon,
            'IncomeSource': income.incomeSourceLabel,
            'IncomeSourceIcon': income.incomeSourceIcon,
            'Notes': income.notes,
            'Amount': income.amount,
            'TimeStamp': income.dateTime,
          });
    } catch (e) {
      debugPrint('$e');
    }
  }
}
