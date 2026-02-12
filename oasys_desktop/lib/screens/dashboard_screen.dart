import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../widgets/layout/app_scaffold.dart';
import '../widgets/layout/responsive_layout.dart';
import '../widgets/shared/empty_state_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return AppScaffold(
      title: 'Oasys Admin',
      actions: [
        IconButton(
          tooltip: 'Trails',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.trails);
          },
          icon: const Icon(Icons.terrain_outlined),
        ),
        IconButton(
          tooltip: 'Odjava',
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
            if (!context.mounted) {
              return;
            }
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
      child: ResponsiveLayout(
        mobile: _buildMobile(authState),
        tablet: _buildTablet(authState),
        desktop: _buildDesktop(authState),
      ),
    );
  }

  Widget _buildMobile(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard', style: AppTextStyles.pageTitle),
        const SizedBox(height: 8),
        Text(
          'Prijavljeni korisnik: ${authState.username ?? 'admin'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        const Expanded(
          child: EmptyStateCard(message: 'No widgets configured yet.'),
        ),
      ],
    );
  }

  Widget _buildTablet(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard', style: AppTextStyles.pageTitle),
        const SizedBox(height: 8),
        Text(
          'Prijavljeni korisnik: ${authState.username ?? 'admin'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        const Expanded(
          child: EmptyStateCard(message: 'Tablet dashboard placeholder.'),
        ),
      ],
    );
  }

  Widget _buildDesktop(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard', style: AppTextStyles.pageTitle),
        const SizedBox(height: 8),
        Text(
          'Prijavljeni korisnik: ${authState.username ?? 'admin'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20),
        const Expanded(
          child: EmptyStateCard(message: 'Desktop dashboard placeholder.'),
        ),
      ],
    );
  }
}
