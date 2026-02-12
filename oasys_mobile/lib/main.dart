import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'screens/auth_bootstrap_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/trails_screen.dart';
import 'utils/app_navigator.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: OasysMobileApp()));
}

class OasysMobileApp extends ConsumerStatefulWidget {
  const OasysMobileApp({super.key});

  @override
  ConsumerState<OasysMobileApp> createState() => _OasysMobileAppState();
}

class _OasysMobileAppState extends ConsumerState<OasysMobileApp> {
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
      title: 'Oasys Mobile',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      scaffoldMessengerKey: AppNavigator.scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF136F63)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.bootstrap,
      routes: {
        AppRoutes.bootstrap: (_) => const AuthBootstrapScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.trails: (_) => const TrailsScreen(),
      },
    );
  }
}
