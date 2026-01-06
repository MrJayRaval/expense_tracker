import 'package:expense_tracker/config/colors.dart';
import 'package:expense_tracker/features/category/presenation/Screens/category_page.dart';
import 'package:expense_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/screens/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool fab;
  late int index;
  final GlobalKey<ScaffoldState> _scaffoldey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    TestingPage(text: 'Dashboard'),
    TestingPage(text: 'Expense History'),
    TestingPage(text: 'Analysis'),
    CategoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    fab = false;
    index = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    return Scaffold(
      key: _scaffoldey,
      backgroundColor: Color(0xFFFBEFEF),
      floatingActionButton: (index == 3)
          ? CategoryFAB()
          : null,
      appBar: AppBar(
        backgroundColor: Color(0xFFFBEFEF),
        // centerTitle: true,
        title: Row(
          
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', 
              height: 25,
            ), 
            
            SizedBox(width: 10,),

            Text("FinWise")],
        ),
      ),
      drawer: NavigationDrawerTheme(
        data: NavigationDrawerThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: secondaryColor);
            } else {
              return Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: onSecondaryColor);
            }
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: onPrimaryColor, size: 30);
            } else {
              return IconThemeData(size: 30);
            }
          }),
        ),
        child: NavigationDrawer(
          onDestinationSelected: (value) {
            setState(() {
              index = value;
            });

            // _scaffoldey.currentState?.closeDrawer();
          },
          selectedIndex: index,
          backgroundColor: Color(0xFFFBEFEF),
          indicatorColor: Color(0xFF85193C),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),

          header: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF6F00FF),
                  child: Icon(Icons.person),
                ),
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

          footer: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 35),
                      SizedBox(width: 10),
                      Text('Logout', style: TextTheme.of(context).titleLarge),
                    ],
                  ),
                ),
              ),
            ),
          ),
          children: [
            SizedBox(height: 10),

            NavigationDrawerDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: Text('Dashboard'),
            ),

            NavigationDrawerDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: Text('Expense History'),
            ),

            NavigationDrawerDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_outlined),
              label: Text('Analysis'),
            ),

            NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Setting'),
            ),
          ],
        ),
      ),
      body: _pages[index],
    );
  }
}
