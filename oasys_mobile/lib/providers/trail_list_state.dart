import 'package:oasys_core/oasys_core.dart';

class TrailListState {
  TrailListState({
    required this.filter,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isMutating,
    required this.items,
    required this.totalCount,
    this.error,
  });

  factory TrailListState.initial() {
    return TrailListState(
      filter: TrailQueryFilter(pageNumber: 1, pageSize: 10),
      isLoading: false,
      isLoadingMore: false,
      isMutating: false,
      items: null,
      totalCount: 0,
      error: null,
    );
  }

  final TrailQueryFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final List<TrailResponse>? items;
  final int totalCount;
  final String? error;

  bool get hasActiveFilter {
    return (filter.search?.trim().isNotEmpty ?? false) ||
        (filter.city?.trim().isNotEmpty ?? false) ||
        filter.difficulty != null;
  }

  bool get hasMore {
    if (items == null) {
      return false;
    }
    return items!.length < totalCount;
  }

  TrailListState copyWith({
    TrailQueryFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    List<TrailResponse>? items,
    int? totalCount,
    String? error,
    bool clearError = false,
  }) {
    return TrailListState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
