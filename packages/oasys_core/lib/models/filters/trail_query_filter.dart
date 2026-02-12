import 'base_query_filter.dart';

class TrailQueryFilter extends BaseQueryFilter {
  TrailQueryFilter({
    super.pageNumber,
    super.pageSize,
    super.search,
    super.sortBy,
    super.sortDescending,
    this.city,
    this.difficulty,
  });

  final String? city;
  final int? difficulty;

  @override
  Map<String, String> toQueryParameters() {
    return <String, String>{
      ...super.toQueryParameters(),
      if (city != null && city!.trim().isNotEmpty) 'city': city!.trim(),
      if (difficulty != null) 'difficulty': difficulty.toString(),
    };
  }
}
