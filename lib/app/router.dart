import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:global_language_distribution_map/features/home/presentation/screens/home_screen.dart';
import 'package:global_language_distribution_map/features/kml_export/presentation/screens/kml_export_screen.dart';
import 'package:global_language_distribution_map/features/map/presentation/screens/map_screen.dart';
import 'package:global_language_distribution_map/features/settings/presentation/screens/settings_screen.dart';
import 'package:global_language_distribution_map/features/splash/presentation/screens/splash_screen.dart';

/// Application route names.
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String home = 'home';
  static const String map = 'map';
  static const String settings = 'settings';
  static const String kmlExport = 'kml-export';
}

/// Application route paths.
class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String home = '/home';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String kmlExport = '/kml-export';
}

/// The main shell with bottom navigation.
class _ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ScaffoldWithNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Creates the application router.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final path = state.uri.path;

      // If the browser lands on a deep link (not splash), skip splash since
      // data is loaded eagerly in main(). Only redirect bare "/" to home.
      if (path == '/') {
        return RoutePaths.home;
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.kmlExport,
        name: RouteNames.kmlExport,
        builder: (context, state) => const KmlExportScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.map,
                name: RouteNames.map,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
