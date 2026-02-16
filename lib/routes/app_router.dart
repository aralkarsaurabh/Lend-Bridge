import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lend_bridge/Request_Money_Screen/borrow_money_screen.dart';
import 'package:lend_bridge/Request_Money_Screen/request_money_main_screen.dart';

import '../Dashboard_Screen/dashboard_screen.dart';
import '../Login_Screen/login_screen.dart';
import '../Main_Screen/main_screen.dart';
import '../Profile_Screen/profile_screen.dart';
import '../Register_Screen/register_screen.dart';
import '../Splash_Screen/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorLendKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellLend',
);
final _shellNavigatorRequestKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellRequest',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSettings',
);

final goRouter = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,

  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNav(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _shellNavigatorLendKey,
          routes: [
            GoRoute(
              path: '/lend',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LendMoneyScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _shellNavigatorRequestKey,
          routes: [
            GoRoute(
              path: '/request',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: RequestMoneyMainScreen()),

              routes: [
                GoRoute(
                  path: 'borrow_new',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: BorrowMoneyScreen()),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            labelSmall: const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          backgroundColor: Colors.black,
          indicatorColor: Colors.grey[800],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              ),
              label: 'Lend',
            ),
            NavigationDestination(
              icon: Icon(Icons.monetization_on_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.monetization_on, color: Colors.white),
              label: 'Request',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.settings, color: Colors.white),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
