import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';
import 'api_exception.dart';

typedef UnauthorizedCallback = Future<void> Function();

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.onUnauthorized,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;
  final UnauthorizedCallback? onUnauthorized;

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) async {
    final uri = _buildUri(path, queryParameters: queryParameters);
    final response = await _httpClient.get(
      uri,
      headers: await _buildHeaders(authenticated: authenticated),
    );

    return _decodeBody(await _handleResponse(response));
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    final uri = _buildUri(path);
    final response = await _httpClient.post(
      uri,
      headers: await _buildHeaders(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _decodeBody(await _handleResponse(response));
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    final uri = _buildUri(path);
    final response = await _httpClient.put(
      uri,
      headers: await _buildHeaders(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _decodeBody(await _handleResponse(response));
  }

  Future<void> delete(
    String path, {
    bool authenticated = true,
  }) async {
    final uri = _buildUri(path);
    final response = await _httpClient.delete(
      uri,
      headers: await _buildHeaders(authenticated: authenticated),
    );

    await _handleResponse(response);
  }

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final withBase = baseUrl.endsWith('/') ? '$baseUrl$normalizedPath' : '$baseUrl/$normalizedPath';
    return Uri.parse(withBase).replace(queryParameters: queryParameters);
  }

  Future<Map<String, String>> _buildHeaders({bool authenticated = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (!authenticated) {
      return headers;
    }

    final token = await TokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      await TokenStorage.clear();
      if (onUnauthorized != null) {
        await onUnauthorized!.call();
      }

      throw ApiException(
        statusCode: 401,
        message: 'Sesija je istekla. Prijavite se ponovo.',
      );
    }

    if (response.statusCode >= 400) {
      throw ApiException.fromResponse(response.statusCode, response.body);
    }

    return response;
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }
}
