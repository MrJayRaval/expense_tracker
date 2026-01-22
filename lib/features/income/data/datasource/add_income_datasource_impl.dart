import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/income/domain/datasource/data_remote_source.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddIncomeDataSourceImpl implements AddIncomeDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  AddIncomeDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<String> getUID() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<void> addIncome(IncomeDetailsModel income) async {
      await firestore
          .collection('users')
          .doc(await getUID())
          .collection('income')
          .add({
            'IncomeType': income.incomeTypeLabel,
            'IncomeTypeIcon': income.incomeTypeIcon,
            'IncomeSource': income.incomeSourceLabel,
            'IncomeSourceIcon': income.incomeSourceIcon,
            'Notes': income.notes,
            'Amount': income.amount,
            'TimeStamp': income.dateTime,
          });
  }
}
