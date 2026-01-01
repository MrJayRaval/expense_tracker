import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/colors.dart';
import 'package:expense_tracker/features/dashboard/data/data/user_repository.dart';
import 'package:expense_tracker/features/dashboard/data/datasources/user_remote_data_source.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/fetch_user_details_usecase.dart';
import 'package:expense_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("FinWise")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashboard.user?['name'] ?? 'No name',
                        style: TextStyle(color: onSecondaryColor, fontSize: 18),
                      ),

                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: TextStyle(color: onSecondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.analytics_outlined),
              title: Text("Add Expense"),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.savings_outlined),
              title: Text("Budget"),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined),
              title: Text("Accounts"),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}
