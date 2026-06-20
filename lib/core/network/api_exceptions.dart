/// Custom exception classes for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

class ServerException extends ApiException {
  const ServerException([String message = 'Server error occurred'])
      : super(message, statusCode: 500);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Unauthorized access'])
      : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  const NotFoundException([String message = 'Resource not found'])
      : super(message, statusCode: 404);
}
