import 'package:oasys_core/oasys_core.dart';

class TrailListState {
  TrailListState({
    required this.filter,
    required this.isLoading,
    required this.isMutating,
    required this.items,
    required this.totalCount,
    this.error,
  });

  factory TrailListState.initial() {
    return TrailListState(
      filter: TrailQueryFilter(pageNumber: 1, pageSize: 10),
      isLoading: false,
      isMutating: false,
      items: null,
      totalCount: 0,
      error: null,
    );
  }

  final TrailQueryFilter filter;
  final bool isLoading;
  final bool isMutating;
  final List<TrailResponse>? items;
  final int totalCount;
  final String? error;

  bool get hasActiveFilter {
    return (filter.search?.trim().isNotEmpty ?? false) ||
        (filter.city?.trim().isNotEmpty ?? false) ||
        filter.difficulty != null;
  }

  int get totalPages {
    if (totalCount <= 0) {
      return 1;
    }
    return (totalCount / filter.pageSize).ceil();
  }

  bool get canGoPrevious => filter.pageNumber > 1;

  bool get canGoNext => filter.pageNumber < totalPages;

  TrailListState copyWith({
    TrailQueryFilter? filter,
    bool? isLoading,
    bool? isMutating,
    List<TrailResponse>? items,
    int? totalCount,
    String? error,
    bool clearError = false,
  }) {
    return TrailListState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isMutating: isMutating ?? this.isMutating,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
