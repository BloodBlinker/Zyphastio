import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/stats/presentation/stats_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../shared/presentation/scaffold_with_navbar.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorTimerKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellTimer',
);
final shellNavigatorStatsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellStats',
);
final shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorTimerKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorStatsKey,
            routes: [
              GoRoute(
                path: '/stats',
                name: 'stats',
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
