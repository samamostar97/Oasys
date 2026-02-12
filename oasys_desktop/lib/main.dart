import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'screens/auth_bootstrap_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/trails_screen.dart';
import 'utils/app_navigator.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: OasysDesktopApp()));
}

class OasysDesktopApp extends ConsumerStatefulWidget {
  const OasysDesktopApp({super.key});

  @override
  ConsumerState<OasysDesktopApp> createState() => _OasysDesktopAppState();
}

class _OasysDesktopAppState extends ConsumerState<OasysDesktopApp> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (!next.isSessionExpired) {
        return;
      }

      AppNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );

      final messenger = AppNavigator.scaffoldMessengerKey.currentState;
      if (messenger != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Sesija je istekla. Prijavite se ponovo.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }

      ref.read(authProvider.notifier).clearSessionExpiredFlag();
    });

    return MaterialApp(
      title: 'Oasys Desktop',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      scaffoldMessengerKey: AppNavigator.scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A6B7A)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.bootstrap,
      routes: {
        AppRoutes.bootstrap: (_) => const AuthBootstrapScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.trails: (_) => const TrailsScreen(),
      },
    );
  }
}
