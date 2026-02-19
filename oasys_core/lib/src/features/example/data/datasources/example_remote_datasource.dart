import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/example_model.dart';

abstract class IExampleRemoteDatasource {
  Future<List<ExampleModel>> getAll();
  Future<ExampleModel>       getById(String id);
  Future<ExampleModel>       create(String title, String description);
  Future<void>               delete(String id);
}

class ExampleRemoteDatasource implements IExampleRemoteDatasource {
  final ApiClient _client;
  ExampleRemoteDatasource(this._client);

  @override
  Future<List<ExampleModel>> getAll() => _client.get(ApiEndpoints.examples,
      fromJson: (d) => (d as List).map((e) => ExampleModel.fromJson(e)).toList());

  @override
  Future<ExampleModel> getById(String id) =>
      _client.get(ApiEndpoints.exampleById(id), fromJson: (d) => ExampleModel.fromJson(d));

  @override
  Future<ExampleModel> create(String title, String description) => _client.post(
      ApiEndpoints.examples,
      data: {'title': title, 'description': description},
      fromJson: (d) => ExampleModel.fromJson(d));

  @override
  Future<void> delete(String id) => _client.delete(ApiEndpoints.exampleById(id));
}
