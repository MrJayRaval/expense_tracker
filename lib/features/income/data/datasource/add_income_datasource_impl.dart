import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasource/data_remote_source.dart';
import '../../domain/entity/income_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddIncomeDataSourceImpl implements IncomeDataSource {
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
