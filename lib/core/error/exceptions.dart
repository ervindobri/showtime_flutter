class ServerException implements Exception {}

class CustomServerException implements Exception {
  String message;

  CustomServerException(this.message);
}

class CacheException implements Exception {}

class RedirectException implements Exception {
  final String cause;

  RedirectException(this.cause);
}
