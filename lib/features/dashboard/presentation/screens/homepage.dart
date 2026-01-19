import 'package:expense_tracker/features/category/presenation/Screens/category_page.dart';
import 'package:expense_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/screens/test.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    IncomePage(),
    CategoryPage(),
    TestingPage(text: 'Setting'),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: (index == 4) ? CategoryFAB() : (index == 3) ? IncomeFAB() : null,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // centerTitle: true,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 25),

            SizedBox(width: 10),

            Text(
              index == 0
                  ? "FinWise"
                  : index == 1
                  ? "Expense History"
                  : index == 2
                  ? "Summary"
                  : index == 3
                  ? "Income"
                  : index == 4
                  ? "Category"
                  : index == 5
                  ? "Setting"
                  : "",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      drawer: NavigationDrawerTheme(
        data: NavigationDrawerThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.surface,
              );
            } else {
              return Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              );
            }
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: Theme.of(context).colorScheme.surface,
                size: 30,
              );
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

            _scaffoldey.currentState?.closeDrawer();
          },
          selectedIndex: index,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          indicatorColor: Theme.of(context).colorScheme.onSurface,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),

          header: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: SizedBox(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    dashboard.user?['name'] ?? 'No name',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          footer: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  await Hive.deleteFromDisk();
                  await FirebaseAuth.instance.signOut();
                },
                child: Row(
                  children: [
                    // Log Out
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(width: 18),
                          Icon(
                            Icons.power_settings_new_rounded,
                            color: Theme.of(context).colorScheme.error,
                            size: 35,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextTheme.of(context).titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ToggleButtons(children: children, isSelected: isSelected)

                    // Theme Set
                  ],
                ),
              ),
            ),
          ),
          children: [
            Divider(),
            
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
              icon: SvgPicture.asset(
                "assets/Images/categoryIcon/categoryicon.svg",
                color: Theme.of(context).colorScheme.onSurface,
              ),
              selectedIcon: SvgPicture.asset(
                "assets/Images/categoryIcon/categoryicon.svg",
                color: Theme.of(context).colorScheme.surface,
              ),
              label: Text('Income'),
            ),

            NavigationDrawerDestination(
              icon: Icon(Icons.currency_rupee_sharp),
              selectedIcon: Icon(Icons.settings),
              label: Text('Category'),
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
