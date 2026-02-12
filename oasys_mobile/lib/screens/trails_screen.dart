import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasys_core/oasys_core.dart';

import '../constants/app_sizes.dart';
import '../providers/trail_list_provider.dart';
import '../providers/trail_list_state.dart';
import '../utils/app_snackbars.dart';
import '../widgets/shared/delete_confirmation_dialog.dart';
import '../widgets/trails/trail_filters_bar.dart';
import '../widgets/trails/trail_form_sheet.dart';
import '../widgets/trails/trail_list_item.dart';

class TrailsScreen extends ConsumerStatefulWidget {
  const TrailsScreen({super.key});

  @override
  ConsumerState<TrailsScreen> createState() => _TrailsScreenState();
}

class _TrailsScreenState extends ConsumerState<TrailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trailListProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trailListProvider);
    final notifier = ref.read(trailListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Staze')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding(context),
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TrailFiltersBar(
                initialSearch: state.filter.search ?? '',
                initialCity: state.filter.city ?? '',
                selectedDifficulty: state.filter.difficulty,
                onSearchChanged: notifier.setSearch,
                onCityChanged: notifier.setCity,
                onDifficultyChanged: notifier.setDifficulty,
                onAddPressed: _createTrail,
                isLoading: state.isLoading || state.isMutating,
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TrailListState state) {
    if (state.isLoading && state.items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(trailListProvider.notifier).refresh(),
              child: const Text('Pokusaj ponovo'),
            ),
          ],
        ),
      );
    }

    final items = state.items ?? <TrailResponse>[];
    if (items.isEmpty) {
      return Center(
        child: Text(
          state.hasActiveFilter
              ? 'Nema rezultata za zadani filter.'
              : 'Jos nema unesenih staza.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => ref.read(trailListProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = items[index];
              return TrailListItem(
                item: item,
                onEdit: _editTrail,
                onDelete: _deleteTrail,
              );
            },
          ),
        ),
        if (state.isLoading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 160) {
      return;
    }

    ref.read(trailListProvider.notifier).loadMore();
  }

  Future<void> _createTrail() async {
    await showTrailFormSheet(
      context,
      onCreate: (request) =>
          ref.read(trailListProvider.notifier).create(request),
    );
  }

  Future<void> _editTrail(TrailResponse item) async {
    await showTrailFormSheet(
      context,
      item: item,
      onUpdate: (request) =>
          ref.read(trailListProvider.notifier).update(item.id, request),
    );
  }

  Future<void> _deleteTrail(TrailResponse item) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      entityName: 'stazu',
      itemName: item.name,
    );

    if (!confirmed) {
      return;
    }

    try {
      await ref.read(trailListProvider.notifier).delete(item.id);
      if (!mounted) {
        return;
      }
      AppSnackbars.success(context, 'Staza uspjesno obrisana.');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      AppSnackbars.error(context, error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackbars.error(
        context,
        'Doslo je do neocekivane greske pri brisanju.',
      );
    }
  }
}
