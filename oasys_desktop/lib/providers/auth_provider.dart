import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasys_core/oasys_core.dart';

import '../config/app_config.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final ApiClient _apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    onUnauthorized: _onUnauthorized,
  );

  late final AuthService _authService = AuthService(apiClient: _apiClient);

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> initialize() async {
    if (state.isInitialized) {
      return;
    }

    try {
      final token = await TokenStorage.readToken();
      state = state.copyWith(
        isInitialized: true,
        isAuthenticated: token != null && token.isNotEmpty,
      );
    } catch (_) {
      state = state.copyWith(
        isInitialized: true,
        isAuthenticated: false,
      );
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final normalizedBaseUrl = AppConfig.apiBaseUrl.trim();
    if (normalizedBaseUrl.isEmpty) {
      throw ApiException(
        statusCode: 500,
        message:
            'API_BASE_URL nije konfigurisan. Pokrenite app sa --dart-define=API_BASE_URL=...',
      );
    }

    state = state.copyWith(
      isLoading: true,
      clearSessionExpired: true,
    );

    try {
      final response = await _authService.loginAdmin(
        AdminLoginRequest(
          username: username.trim(),
          password: password,
        ),
      );

      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        isAuthenticated: true,
        username: response.username,
        role: response.role,
        clearSessionExpired: true,
      );
    } on ApiException {
      state = state.copyWith(isLoading: false);
      rethrow;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      throw ApiException(
        statusCode: 500,
        message: 'Došlo je do neočekivane greške pri prijavi.',
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = state.copyWith(
      isInitialized: true,
      isLoading: false,
      isAuthenticated: false,
      clearIdentity: true,
      clearSessionExpired: true,
    );
  }

  Future<void> _onUnauthorized() async {
    await _authService.logout();
    state = state.copyWith(
      isInitialized: true,
      isLoading: false,
      isAuthenticated: false,
      clearIdentity: true,
      isSessionExpired: true,
    );
  }

  Future<void> handleUnauthorized() {
    return _onUnauthorized();
  }

  void clearSessionExpiredFlag() {
    if (!state.isSessionExpired) {
      return;
    }

    state = state.copyWith(clearSessionExpired: true);
  }
}

class AuthState {
  const AuthState({
    required this.isInitialized,
    required this.isLoading,
    required this.isAuthenticated,
    required this.isSessionExpired,
    this.username,
    this.role,
  });

  const AuthState.initial()
      : isInitialized = false,
        isLoading = false,
        isAuthenticated = false,
        isSessionExpired = false,
        username = null,
        role = null;

  final bool isInitialized;
  final bool isLoading;
  final bool isAuthenticated;
  final bool isSessionExpired;
  final String? username;
  final String? role;

  AuthState copyWith({
    bool? isInitialized,
    bool? isLoading,
    bool? isAuthenticated,
    bool? isSessionExpired,
    bool clearSessionExpired = false,
    bool clearIdentity = false,
    String? username,
    String? role,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSessionExpired:
          clearSessionExpired ? false : (isSessionExpired ?? this.isSessionExpired),
      username: clearIdentity ? null : (username ?? this.username),
      role: clearIdentity ? null : (role ?? this.role),
    );
  }
}
