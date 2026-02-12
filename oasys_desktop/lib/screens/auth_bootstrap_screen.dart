import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';

class AuthBootstrapScreen extends ConsumerStatefulWidget {
  const AuthBootstrapScreen({super.key});

  @override
  ConsumerState<AuthBootstrapScreen> createState() =>
      _AuthBootstrapScreenState();
}

class _AuthBootstrapScreenState extends ConsumerState<AuthBootstrapScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).initialize());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isInitialized && !_hasNavigated) {
      _hasNavigated = true;
      final destination =
          authState.isAuthenticated ? AppRoutes.dashboard : AppRoutes.login;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushNamedAndRemoveUntil(destination, (_) => false);
      });
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
