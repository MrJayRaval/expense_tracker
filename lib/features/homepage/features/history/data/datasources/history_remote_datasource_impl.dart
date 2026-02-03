import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import '../../domain/datasource/history_remote_datasource.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryRemoteDatasourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  HistoryRemoteDatasourceImpl({required this.firestore, required this.auth});

  @override
  Future<List<TransactionDetailsModel>> fetchTransactionHistory(TransactionType transactionType, ) async {
    String uid = auth.currentUser!.uid;
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection(transactionType.name, )
        .orderBy('TimeStamp', descending: true)
        .get();

    return snapshot.docs
        .map((e) => TransactionDetailsModel.fromJson(e.data(), e.id))
        .toList();
  }

  @override
  Future<void> deleteParticularTransaction(TransactionType transactionType, String id) async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection('users')
        .doc(uid)
        .collection(transactionType.name, )
        .doc(id)
        .delete();
  }

  @override
  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel transaction) async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection(transactionType.name)
          .doc(transaction.id)
          .update({
            'TransactionType': transaction.transactionCategoryLabel,
            'TransactionTypeIcon': transaction.transactionCategoryIcon,
            'TransactionSource': transaction.transactionSourceLabel,
            'TransactionSourceIcon': transaction.transactionSourceIcon,
            'Notes': transaction.notes,
            'Amount': transaction.amount,
            'TimeStamp': transaction.dateTime,
          });
    } catch (e) {
      debugPrint('$e');
    }
  }
}
