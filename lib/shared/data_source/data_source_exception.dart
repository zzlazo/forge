abstract class DataSourceException implements Exception {
  final String message;
  final dynamic originalError;

  DataSourceException(this.message, [this.originalError]);

  @override
  String toString() {
    if (originalError != null) {
      return '$runtimeType: $message (Original Error: $originalError)';
    }
    return '$runtimeType: $message';
  }
}

class GetPassException extends DataSourceException {
  GetPassException(String message, [dynamic originalError])
    : super('GetPassException: $message', originalError);
}

class MissingDeckParameterException extends DataSourceException {
  final List<String> missingParameters;
  MissingDeckParameterException(this.missingParameters)
    : super('MissingDeckParameterException: ${missingParameters.join(', ')}');
}

class FileNotFoundException extends DataSourceException {
  final String fileName;
  FileNotFoundException(this.fileName)
    : super('FileNotFoundException: $fileName');
}

class FileLoadException extends DataSourceException {
  final String fileName;
  FileLoadException(this.fileName, String message)
    : super('FileNotFoundException: $fileName, message: $message');
}

class FileSaveException extends DataSourceException {
  final String fileName;
  FileSaveException(this.fileName, String errorMessage)
    : super('Failed to save file "$fileName": $errorMessage');
}

class FileDeleteException extends DataSourceException {
  final String fileName;
  FileDeleteException(this.fileName, String errorMessage)
    : super('Failed to delete file "$fileName": $errorMessage');
}

class JsonDecodeException extends DataSourceException {
  final String content;
  JsonDecodeException(this.content, String errorMessage)
    : super(
        'Failed to decode JSON: $errorMessage. Content: "${content.substring(0, content.length > 100 ? 100 : content.length)}..."',
      );
}

class DataModelConversionException extends DataSourceException {
  final String modelName;
  DataModelConversionException(this.modelName, String errorMessage)
    : super('Failed to convert to $modelName model: $errorMessage');
}

class UnexpectedParsingException extends DataSourceException {
  UnexpectedParsingException(String errorMessage, [dynamic originalError])
    : super(
        'An unexpected parsing error occurred: $errorMessage',
        originalError,
      );
}

class PermissionDeniedException extends DataSourceException {
  PermissionDeniedException(String message, [dynamic originalError])
    : super('Permission denied: $message', originalError);
}

class OperationCanceledException extends DataSourceException {
  OperationCanceledException(String message, [dynamic originalError])
    : super('Operation canceled: $message', originalError);
}
