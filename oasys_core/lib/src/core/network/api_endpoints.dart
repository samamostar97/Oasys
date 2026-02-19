class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl  = 'https://localhost:7001';
  static const String login    = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String examples = '/api/examples';
  static String exampleById(String id) => '/api/examples/$id';
}
