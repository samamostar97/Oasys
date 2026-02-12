class BaseQueryFilter {
  BaseQueryFilter({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.search,
    this.sortBy,
    this.sortDescending = false,
  });

  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final bool sortDescending;

  Map<String, String> toQueryParameters() {
    return <String, String>{
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
      if (sortBy != null && sortBy!.trim().isNotEmpty) 'sortBy': sortBy!.trim(),
      'sortDescending': sortDescending.toString(),
    };
  }
}
