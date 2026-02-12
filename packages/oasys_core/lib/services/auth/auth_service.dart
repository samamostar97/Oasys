import '../../api/api_client.dart';
import '../../models/requests/admin_login_request.dart';
import '../../models/responses/auth_response.dart';
import '../../storage/token_storage.dart';

class AuthService {
  AuthService({required this.apiClient});

  final ApiClient apiClient;

  Future<AuthResponse> loginAdmin(AdminLoginRequest request) async {
    final response = await apiClient.post(
      '/auth/login/admin',
      body: request.toJson(),
      authenticated: false,
    );

    final parsed = AuthResponse.fromJson(response as Map<String, dynamic>);
    await TokenStorage.saveToken(parsed.token);
    return parsed;
  }

  Future<void> logout() {
    return TokenStorage.clear();
  }
}
