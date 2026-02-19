import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../storage/token_storage.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    dio = Dio(BaseOptions(
      baseUrl: 'https://localhost:7001',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ))
      ..interceptors.add(_AuthInterceptor(_tokenStorage))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters, required T Function(dynamic) fromJson}) async {
    try { final r = await dio.get(path, queryParameters: queryParameters); return fromJson(r.data); }
    on DioException catch (e) { throw _handle(e); }
  }

  Future<T> post<T>(String path, {dynamic data, required T Function(dynamic) fromJson}) async {
    try { final r = await dio.post(path, data: data); return fromJson(r.data); }
    on DioException catch (e) { throw _handle(e); }
  }

  Future<T> put<T>(String path, {dynamic data, required T Function(dynamic) fromJson}) async {
    try { final r = await dio.put(path, data: data); return fromJson(r.data); }
    on DioException catch (e) { throw _handle(e); }
  }

  Future<void> delete(String path) async {
    try { await dio.delete(path); }
    on DioException catch (e) { throw _handle(e); }
  }

  Exception _handle(DioException e) {
    if (e.type == DioExceptionType.connectionError) return const NetworkException();
    return switch (e.response?.statusCode) {
      401 => const UnauthorizedException(),
      404 => NotFoundException(e.message ?? 'Not found'),
      _   => ServerException(e.message ?? 'Server error', statusCode: e.response?.statusCode),
    };
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}
