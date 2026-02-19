import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;
  static const _tokenKey   = 'auth_token';
  static const _refreshKey = 'refresh_token';

  TokenStorage(this._storage);

  Future<void>    saveToken(String t)        => _storage.write(key: _tokenKey,   value: t);
  Future<String?> getToken()                 => _storage.read(key: _tokenKey);
  Future<void>    saveRefreshToken(String t) => _storage.write(key: _refreshKey, value: t);
  Future<String?> getRefreshToken()          => _storage.read(key: _refreshKey);
  Future<void>    clear()                    => _storage.deleteAll();
}
