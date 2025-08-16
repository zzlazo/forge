abstract class ApplicationException implements Exception {
  final String message;
  final dynamic originalError;

  ApplicationException(this.message, [this.originalError]);

  @override
  String toString() {
    if (originalError != null) {
      return '$runtimeType: $message (Original Error: $originalError)';
    }
    return '$runtimeType: $message';
  }
}

class DataAccessException extends ApplicationException {
  DataAccessException(String message, [dynamic originalError])
    : super('Data access failed: $message', originalError);
}

class DataNotFoundException extends ApplicationException {
  DataNotFoundException(String message, [dynamic originalError])
    : super('Data not found: $message', originalError);
}

class InvalidDataException extends ApplicationException {
  InvalidDataException(String message, [dynamic originalError])
    : super('Invalid data format: $message', originalError);
}

class InternalErrorException extends ApplicationException {
  InternalErrorException(String message, [dynamic originalError])
    : super('An internal error occurred: $message', originalError);
}

class PermissionRequiredException extends ApplicationException {
  PermissionRequiredException(String message, [dynamic originalError])
    : super(
        'Permission is required for this operation: $message',
        originalError,
      );
}

class UserCancelledException extends ApplicationException {
  UserCancelledException(String message, [dynamic originalError])
    : super('Operation cancelled by user: $message', originalError);
}

class MultipleErrorsException extends ApplicationException {
  final List<ApplicationException> errors;

  MultipleErrorsException(String message, this.errors, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() {
    final errorMessages = errors.map((e) => e.toString()).join('\n  ');
    return '$runtimeType: $message\nErrors:\n  $errorMessages';
  }
}
