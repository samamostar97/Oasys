import '../../api/api_client.dart';
import '../../models/common/paged_result.dart';
import '../../models/filters/base_query_filter.dart';

abstract class CrudService<TResponse, TCreateRequest, TUpdateRequest,
    TFilter extends BaseQueryFilter> {
  CrudService({required this.apiClient, required this.resourcePath});

  final ApiClient apiClient;
  final String resourcePath;

  TResponse fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toCreateJson(TCreateRequest request);

  Map<String, dynamic> toUpdateJson(TUpdateRequest request);

  Future<PagedResult<TResponse>> getPaged(TFilter filter) async {
    final response = await apiClient.get(
      resourcePath,
      queryParameters: filter.toQueryParameters(),
    );

    if (response is! Map<String, dynamic>) {
      return PagedResult<TResponse>(
        items: <TResponse>[],
        totalCount: 0,
        pageNumber: filter.pageNumber,
        pageSize: filter.pageSize,
      );
    }

    return PagedResult<TResponse>.fromJson(response, fromJson);
  }

  Future<TResponse> getById(int id) async {
    final response = await apiClient.get('$resourcePath/$id');
    return fromJson(response as Map<String, dynamic>);
  }

  Future<TResponse> create(TCreateRequest request) async {
    final response = await apiClient.post(
      resourcePath,
      body: toCreateJson(request),
    );

    return fromJson(response as Map<String, dynamic>);
  }

  Future<TResponse> update(int id, TUpdateRequest request) async {
    final response = await apiClient.put(
      '$resourcePath/$id',
      body: toUpdateJson(request),
    );

    return fromJson(response as Map<String, dynamic>);
  }

  Future<void> delete(int id) {
    return apiClient.delete('$resourcePath/$id');
  }
}
