class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException([this.message = 'Server Exception Occurred', this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network Exception Occurred']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache Exception Occurred']);

  @override
  String toString() => 'CacheException: $message';
}
