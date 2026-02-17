import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import '../../domain/datasource/data_remote_source.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionDataSourceImpl implements TransactionDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TransactionDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<String> getUID() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<void> addTransactions(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    final type = transactionType == TransactionType.income
        ? 'income'
        : 'expense';
    firestore
        .collection('users')
        .doc(await getUID())
        .collection(type)
        .add({
          'TransactionSource': transaction.transactionSourceLabel,
          'TransactionCategoryIcon': transaction.transactionCategoryIcon,
          'TransactionCategory': transaction.transactionCategoryLabel,
          'TransactionSourceIcon': transaction.transactionSourceIcon,
          'Notes': transaction.notes,
          'Amount': transaction.amount,
          'TimeStamp': transaction.dateTime,
        })
        .then((_) {
          log('TRANSACTION ADDED TO FIREBASE DATABASE');
        });
  }
}
