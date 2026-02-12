import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../widgets/layout/mobile_scaffold.dart';
import '../widgets/shared/section_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MobileScaffold(
      title: 'Oasys Mobile',
      actions: [
        IconButton(
          tooltip: 'Odjava',
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
            if (!context.mounted) {
              return;
            }
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dobrodošli, ${authState.username ?? 'admin'}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: 'Dashboard',
            description:
                'Osnovni mobile auth flow je aktivan. Sljedeći korak je dodavanje feature ekrana i list/detail tokova.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.trails),
            icon: const Icon(Icons.terrain_outlined),
            label: const Text('Otvori staze'),
          ),
        ],
      ),
    );
  }
}
