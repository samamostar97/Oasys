import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasys_core/oasys_core.dart';

import '../config/app_config.dart';
import 'auth_provider.dart';
import 'trail_list_state.dart';

final trailListProvider =
    NotifierProvider.autoDispose<TrailListNotifier, TrailListState>(
      TrailListNotifier.new,
    );

class TrailListNotifier extends Notifier<TrailListState> {
  late final TrailService _trailService;

  @override
  TrailListState build() {
    final authNotifier = ref.read(authProvider.notifier);

    _trailService = TrailService(
      apiClient: ApiClient(
        baseUrl: AppConfig.apiBaseUrl,
        onUnauthorized: authNotifier.handleUnauthorized,
      ),
    );

    return TrailListState.initial();
  }

  Future<void> load() {
    return _fetchPage(pageNumber: 1, append: false);
  }

  Future<void> refresh() {
    return _fetchPage(pageNumber: 1, append: false);
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    await _fetchPage(pageNumber: state.filter.pageNumber + 1, append: true);
  }

  Future<void> setSearch(String value) async {
    final normalized = value.trim();
    final nextFilter = _filterWith(
      pageNumber: 1,
      search: normalized.isEmpty ? null : normalized,
      replaceSearch: true,
    );

    await _fetchPage(pageNumber: 1, append: false, overrideFilter: nextFilter);
  }

  Future<void> setCity(String value) async {
    final normalized = value.trim();
    final nextFilter = _filterWith(
      pageNumber: 1,
      city: normalized.isEmpty ? null : normalized,
      replaceCity: true,
    );

    await _fetchPage(pageNumber: 1, append: false, overrideFilter: nextFilter);
  }

  Future<void> setDifficulty(int? difficulty) async {
    final nextFilter = _filterWith(
      pageNumber: 1,
      difficulty: difficulty,
      replaceDifficulty: true,
    );

    await _fetchPage(pageNumber: 1, append: false, overrideFilter: nextFilter);
  }

  Future<void> create(CreateTrailRequest request) {
    return _runMutation(
      action: () => _trailService.create(request),
      fallbackError: 'Doslo je do neocekivane greske pri kreiranju staze.',
    );
  }

  Future<void> update(int id, UpdateTrailRequest request) {
    return _runMutation(
      action: () => _trailService.update(id, request),
      fallbackError: 'Doslo je do neocekivane greske pri izmjeni staze.',
    );
  }

  Future<void> delete(int id) {
    return _runMutation(
      action: () => _trailService.delete(id),
      fallbackError: 'Doslo je do neocekivane greske pri brisanju staze.',
    );
  }

  Future<void> _fetchPage({
    required int pageNumber,
    required bool append,
    TrailQueryFilter? overrideFilter,
  }) async {
    final targetFilter = overrideFilter ?? _filterWith(pageNumber: pageNumber);

    state = state.copyWith(
      filter: targetFilter,
      isLoading: !append,
      isLoadingMore: append,
      clearError: true,
    );

    try {
      final result = await _trailService.getPaged(targetFilter);
      final mergedItems = append
          ? <TrailResponse>[...?state.items, ...result.items]
          : result.items;

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        items: mergedItems,
        totalCount: result.totalCount,
      );
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: 'Doslo je do neocekivane greske pri ucitavanju staza.',
      );
    }
  }

  TrailQueryFilter _filterWith({
    int? pageNumber,
    String? search,
    String? city,
    int? difficulty,
    bool replaceSearch = false,
    bool replaceCity = false,
    bool replaceDifficulty = false,
  }) {
    return TrailQueryFilter(
      pageNumber: pageNumber ?? state.filter.pageNumber,
      pageSize: state.filter.pageSize,
      search: replaceSearch ? search : (search ?? state.filter.search),
      city: replaceCity ? city : (city ?? state.filter.city),
      difficulty: replaceDifficulty
          ? difficulty
          : (difficulty ?? state.filter.difficulty),
      sortBy: state.filter.sortBy,
      sortDescending: state.filter.sortDescending,
    );
  }

  Future<void> _runMutation({
    required Future<void> Function() action,
    required String fallbackError,
  }) async {
    state = state.copyWith(isMutating: true, clearError: true);

    try {
      await action();
      await refresh();
    } on ApiException catch (error) {
      state = state.copyWith(error: error.message);
      rethrow;
    } catch (_) {
      state = state.copyWith(error: fallbackError);
      rethrow;
    } finally {
      state = state.copyWith(isMutating: false);
    }
  }
}
