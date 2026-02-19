abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure       extends Failure { final int? statusCode; const ServerFailure(super.m, {this.statusCode}); }
class NetworkFailure      extends Failure { const NetworkFailure([super.m = 'No internet connection']); }
class UnauthorizedFailure extends Failure { const UnauthorizedFailure([super.m = 'Unauthorized']); }
class NotFoundFailure     extends Failure { const NotFoundFailure(super.m); }
class ValidationFailure   extends Failure { const ValidationFailure(super.m); }
class CacheFailure        extends Failure { const CacheFailure(super.m); }
