/// Exception thrown when a server responds with an error.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when there is no network connectivity.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when local cache operations fail.
class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when the user is not authenticated or the session expired.
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException([this.message = 'Session expired']);

  @override
  String toString() => 'UnauthorizedException: $message';
}
