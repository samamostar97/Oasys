import '../../models/filters/trail_query_filter.dart';
import '../../models/requests/create_trail_request.dart';
import '../../models/requests/update_trail_request.dart';
import '../../models/responses/trail_response.dart';
import '../base/crud_service.dart';

class TrailService
    extends
        CrudService<
          TrailResponse,
          CreateTrailRequest,
          UpdateTrailRequest,
          TrailQueryFilter
        > {
  TrailService({required super.apiClient}) : super(resourcePath: '/trails');

  @override
  TrailResponse fromJson(Map<String, dynamic> json) {
    return TrailResponse.fromJson(json);
  }

  @override
  Map<String, dynamic> toCreateJson(CreateTrailRequest request) {
    return request.toJson();
  }

  @override
  Map<String, dynamic> toUpdateJson(UpdateTrailRequest request) {
    return request.toJson();
  }
}
