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

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _trailService.getPaged(state.filter);
      state = state.copyWith(
        isLoading: false,
        items: result.items,
        totalCount: result.totalCount,
      );
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, error: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Doslo je do neocekivane greske pri ucitavanju staza.',
      );
    }
  }

  Future<void> refresh() {
    return load();
  }

  Future<void> setSearch(String value) async {
    final normalized = value.trim();
    state = state.copyWith(
      filter: _filterWith(
        pageNumber: 1,
        search: normalized.isEmpty ? null : normalized,
        replaceSearch: true,
      ),
    );

    await load();
  }

  Future<void> setCity(String value) async {
    final normalized = value.trim();
    state = state.copyWith(
      filter: _filterWith(
        pageNumber: 1,
        city: normalized.isEmpty ? null : normalized,
        replaceCity: true,
      ),
    );

    await load();
  }

  Future<void> setDifficulty(int? difficulty) async {
    state = state.copyWith(
      filter: _filterWith(
        pageNumber: 1,
        difficulty: difficulty,
        replaceDifficulty: true,
      ),
    );

    await load();
  }

  Future<void> setSortBy(String? sortBy, {required bool descending}) async {
    final normalized = sortBy?.trim() ?? '';
    state = state.copyWith(
      filter: _filterWith(
        pageNumber: 1,
        sortBy: normalized.isEmpty ? null : normalized,
        sortDescending: descending,
        replaceSortBy: true,
      ),
    );

    await load();
  }

  Future<void> goToPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > state.totalPages) {
      return;
    }

    state = state.copyWith(filter: _filterWith(pageNumber: pageNumber));

    await load();
  }

  Future<void> create(CreateTrailRequest request) async {
    return _runMutation(
      action: () => _trailService.create(request),
      fallbackError: 'Doslo je do neocekivane greske pri kreiranju staze.',
    );
  }

  Future<void> update(int id, UpdateTrailRequest request) async {
    return _runMutation(
      action: () => _trailService.update(id, request),
      fallbackError: 'Doslo je do neocekivane greske pri izmjeni staze.',
    );
  }

  Future<void> delete(int id) async {
    return _runMutation(
      action: () async {
        await _trailService.delete(id);

        final shouldGoBackOnePage =
            state.items != null &&
            state.items!.length == 1 &&
            state.filter.pageNumber > 1;

        if (shouldGoBackOnePage) {
          state = state.copyWith(
            filter: _filterWith(pageNumber: state.filter.pageNumber - 1),
          );
        }
      },
      fallbackError: 'Doslo je do neocekivane greske pri brisanju staze.',
    );
  }

  TrailQueryFilter _filterWith({
    int? pageNumber,
    int? pageSize,
    String? search,
    String? sortBy,
    bool? sortDescending,
    String? city,
    int? difficulty,
    bool replaceSearch = false,
    bool replaceSortBy = false,
    bool replaceCity = false,
    bool replaceDifficulty = false,
  }) {
    return TrailQueryFilter(
      pageNumber: pageNumber ?? state.filter.pageNumber,
      pageSize: pageSize ?? state.filter.pageSize,
      search: replaceSearch ? search : (search ?? state.filter.search),
      sortBy: replaceSortBy ? sortBy : (sortBy ?? state.filter.sortBy),
      sortDescending: sortDescending ?? state.filter.sortDescending,
      city: replaceCity ? city : (city ?? state.filter.city),
      difficulty: replaceDifficulty
          ? difficulty
          : (difficulty ?? state.filter.difficulty),
    );
  }

  Future<void> _runMutation({
    required Future<void> Function() action,
    required String fallbackError,
  }) async {
    state = state.copyWith(isMutating: true, clearError: true);

    try {
      await action();
      await load();
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
