import 'dart:convert';

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message, this.details});

  final int statusCode;
  final String message;
  final Object? details;

  factory ApiException.fromResponse(int statusCode, String body) {
    if (body.isEmpty) {
      return ApiException(
        statusCode: statusCode,
        message: 'Request failed with status code $statusCode.',
      );
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return ApiException(
          statusCode: statusCode,
          message: (decoded['message'] ?? 'Request failed with status code $statusCode.') as String,
          details: decoded,
        );
      }
    } catch (_) {
      // Fall through to generic message when body is not JSON.
    }

    return ApiException(
      statusCode: statusCode,
      message: 'Request failed with status code $statusCode.',
      details: body,
    );
  }

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}
