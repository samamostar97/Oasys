class ServerException      implements Exception { final String message; final int? statusCode; const ServerException(this.message, {this.statusCode}); }
class NetworkException     implements Exception { const NetworkException(); }
class UnauthorizedException implements Exception { const UnauthorizedException(); }
class NotFoundException    implements Exception { final String message; const NotFoundException(this.message); }
class CacheException       implements Exception { final String message; const CacheException(this.message); }
