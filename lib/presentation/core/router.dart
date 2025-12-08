import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/forecast_screen.dart';
import '../screens/aqi_screen.dart';
import '../screens/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import 'theme.dart';

import '../screens/splash_screen.dart';

/// Router configuration cho ứng dụng
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationWrapper(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/forecast',
            builder: (context, state) => const ForecastScreen(),
          ),
          GoRoute(
            path: '/aqi',
            builder: (context, state) => const AQIScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

/// Wrapper cho bottom navigation
class MainNavigationWrapper extends StatelessWidget {
  final Widget child;
  final String location;

  const MainNavigationWrapper({
    super.key,
    required this.location,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(location),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/forecast');
              break;
            case 2:
              context.go('/aqi');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l10n.forecast,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.air),
            label: l10n.aqi,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/forecast':
        return 1;
      case '/aqi':
        return 2;
      case '/settings':
        return 3;
      default:
        return 0;
    }
  }
}

