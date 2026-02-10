import 'package:expense_tracker/features/homepage/features/dashboard/presenation/Screens/dashboard_page.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';

import '../../../../config/theme_helper.dart';
import '../../features/history/presenation/Screens/history_page.dart';
import '../../features/category/presenation/Screens/category_page.dart';
import '../providers/dashboard_provider.dart';
import 'test.dart';
import '../../features/transaction/presentaion/screens/income_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = const [
    DashboardPage(),
    HistoryPage(),
    TestingPage(text: 'Analysis'),
    IncomePage(),
    CategoryPage(),
    TestingPage(text: 'Setting'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageProvider>().fetchUserDetails();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/logo.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeHelper.surface,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      floatingActionButton: _buildFAB(),
      body: _pages[_selectedIndex], // lazy load pages
    );
  }

  // ---------------- APP BAR ----------------

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    const titles = [
      'FinWise',
      'History',
      'Summary',
      'Income',
      'Categories',
      'Settings',
    ];

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      title: Row(
        children: [
          Image.asset('assets/logo.png', height: 24),
          const SizedBox(width: 10),
          Text(
            titles[_selectedIndex],
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: ThemeHelper.onSurface),
          ),
        ],
      ),
    );
  }

  // ---------------- FAB ----------------

  Widget? _buildFAB() {
    if (_selectedIndex == 1) return HistoryFAB();
    if (_selectedIndex == 4) return CategoryFAB();
    if (_selectedIndex == 3) return AddTransactionFAB();
    return null;
  }

  // ---------------- DRAWER ----------------

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeHelper.onPrimary,
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),
            const Divider(),
            Expanded(child: _buildDrawerList()),
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Consumer<HomePageProvider>(
      builder: (_, dashboard, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: ThemeHelper.onSurface,
                child: Icon(Icons.person, size: 45, color: ThemeHelper.surface),
              ),
              const SizedBox(height: 12),
              Text(
                dashboard.user?['name'] ?? 'Loading...',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: ThemeHelper.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: TextStyle(color: ThemeHelper.onSurface),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _drawerTile(Icons.home, 'Dashboard', 0),
        _drawerTile(Icons.receipt_long, 'History', 1),
        _drawerTile(Icons.bar_chart, 'Analysis', 2),
        _drawerTile(Icons.trending_up, 'Income', 3),
        _drawerTile(Icons.category, 'Categories', 4),
        _drawerTile(Icons.settings, 'Settings', 5),
      ],
    );
  }

  ListTile _drawerTile(IconData icon, String label, int index) {
    final bool selected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? ThemeHelper.primary : ThemeHelper.onSurface,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: selected ? ThemeHelper.primary : ThemeHelper.onSurface,
        ),
      ),
      selected: selected,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildDrawerFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        leading: Icon(
          Icons.power_settings_new_rounded,
          color: ThemeHelper.error,
        ),
        title: Text(
          'Logout',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: ThemeHelper.error),
        ),
        onTap: () async {
          await Hive.deleteFromDisk();
          await FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}
