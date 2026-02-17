import 'package:expense_tracker/features/homepage/features/dashboard/presenation/Screens/dashboard_page.dart';

import '../../../../config/theme_helper.dart';
import '../../features/history/presenation/Screens/history_page.dart';
import 'package:expense_tracker/features/homepage/features/expense/presentation/screens/expense_page.dart';
import '../../features/history/presenation/providers/history_provider.dart';
import '../providers/homepage_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/income_page.dart';
import 'package:expense_tracker/features/settings/presentation/screens/settings_page.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    DashboardPage(),
    HistoryPage(),
    IncomePage(),
    ExpensePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageProvider>().fetchUserDetails();
      context.read<HistoryProvider>().loadTransaction();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/logo.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }

        // Handle drawer if it's open
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }

        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ThemeHelper.surface,
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        floatingActionButton: _buildFAB(),
        body: _pages[_selectedIndex], // lazy load pages
      ),
    );
  }

  // ---------------- APP BAR ----------------

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    const titles = ['FinWise', 'History', 'Income', 'Expenses', 'Settings'];
    final title = titles[_selectedIndex];

    return AppBar(
      backgroundColor: ThemeHelper.surface,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu_rounded, color: ThemeHelper.onSurface),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          if (_selectedIndex == 0) ...[
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: ThemeHelper.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/logo.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeHelper.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        if (_selectedIndex == 0)
          GestureDetector(
            onTap: () {
              // Navigate to profile or settings
              setState(() {
                _selectedIndex = 4; // Settings
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeHelper.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Consumer<HomePageProvider>(
                builder: (_, dashboard, __) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: ThemeHelper.primaryContainer,
                    child: Text(
                      (dashboard.user?['name'] ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        color: ThemeHelper.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  // ---------------- FAB ----------------

  Widget? _buildFAB() {
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
        _drawerTile(Icons.trending_up, 'Income', 2),
        _drawerTile(Icons.category, 'Expenses', 3),
        _drawerTile(Icons.settings, 'Settings', 4),
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
          final authProvider = context.read<AuthProvider>();
          await authProvider.signOut();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
