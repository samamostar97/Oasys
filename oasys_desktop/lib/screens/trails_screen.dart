import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasys_core/oasys_core.dart';

import '../constants/app_text_styles.dart';
import '../providers/trail_list_provider.dart';
import '../providers/trail_list_state.dart';
import '../utils/app_snackbars.dart';
import '../widgets/layout/app_scaffold.dart';
import '../widgets/shared/delete_confirmation_dialog.dart';
import '../widgets/shared/empty_state_card.dart';
import '../widgets/trails/trail_filters_bar.dart';
import '../widgets/trails/trail_form_dialog.dart';
import '../widgets/trails/trail_table.dart';

class TrailsScreen extends ConsumerStatefulWidget {
  const TrailsScreen({super.key});

  @override
  ConsumerState<TrailsScreen> createState() => _TrailsScreenState();
}

class _TrailsScreenState extends ConsumerState<TrailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trailListProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trailListProvider);
    final notifier = ref.read(trailListProvider.notifier);

    return AppScaffold(
      title: 'Staze',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Story Trails', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          Text(
            'Pregled i upravljanje trail entitetima.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TrailFiltersBar(
            initialSearch: state.filter.search ?? '',
            initialCity: state.filter.city ?? '',
            selectedDifficulty: state.filter.difficulty,
            selectedSortBy: state.filter.sortBy,
            sortDescending: state.filter.sortDescending,
            onSearchChanged: (value) => notifier.setSearch(value),
            onCityChanged: (value) => notifier.setCity(value),
            onDifficultyChanged: (value) => notifier.setDifficulty(value),
            onSortChanged: (sortBy, descending) =>
                notifier.setSortBy(sortBy, descending: descending),
            onAddPressed: _openCreateDialog,
            isLoading: state.isLoading || state.isMutating,
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildBody(state)),
        ],
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
      return EmptyStateCard(
        message: state.hasActiveFilter
            ? 'Nema rezultata za zadani filter.'
            : 'Jos nema unesenih staza.',
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: TrailTable(
                items: items,
                onEdit: _openEditDialog,
                onDelete: _deleteTrail,
              ),
            ),
            const SizedBox(height: 12),
            _buildPagination(state),
          ],
        ),
        if (state.isLoading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildPagination(TrailListState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ukupno: ${state.totalCount}'),
          const SizedBox(width: 16),
          IconButton(
            tooltip: 'Prethodna stranica',
            onPressed: (!state.canGoPrevious || state.isLoading)
                ? null
                : () => ref
                      .read(trailListProvider.notifier)
                      .goToPage(state.filter.pageNumber - 1),
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Stranica ${state.filter.pageNumber} / ${state.totalPages}'),
          IconButton(
            tooltip: 'Sljedeca stranica',
            onPressed: (!state.canGoNext || state.isLoading)
                ? null
                : () => ref
                      .read(trailListProvider.notifier)
                      .goToPage(state.filter.pageNumber + 1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return TrailFormDialog(
          onCreate: (request) =>
              ref.read(trailListProvider.notifier).create(request),
        );
      },
    );
  }

  Future<void> _openEditDialog(TrailResponse item) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return TrailFormDialog(
          item: item,
          onUpdate: (request) =>
              ref.read(trailListProvider.notifier).update(item.id, request),
        );
      },
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
