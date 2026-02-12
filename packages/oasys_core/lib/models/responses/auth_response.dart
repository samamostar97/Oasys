class AuthResponse {
  AuthResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.username,
    required this.role,
  });

  final String token;
  final DateTime expiresAtUtc;
  final String username;
  final String role;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: (json['token'] as String?) ?? '',
      expiresAtUtc: DateTime.tryParse((json['expiresAtUtc'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      username: (json['username'] as String?) ?? '',
      role: (json['role'] as String?) ?? '',
    );
  }
}
