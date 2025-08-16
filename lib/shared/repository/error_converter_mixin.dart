import '../application/application_exception.dart';
import '../data_source/data_source_exception.dart';

mixin ErrorConverterMixin {
  Future<T> wrapDataSourceCall<T>(Future<T> Function() dataSourceCall) async {
    try {
      return await dataSourceCall();
    } on FileNotFoundException catch (e) {
      throw DataNotFoundException('File not found: ${e.fileName}');
    } on FileLoadException catch (e) {
      throw DataAccessException('Failed to load file: ${e.fileName}', e);
    } on FileSaveException catch (e) {
      throw DataAccessException('Failed to save file: ${e.fileName}', e);
    } on FileDeleteException catch (e) {
      throw DataAccessException('Failed to delete file: ${e.fileName}', e);
    } on JsonDecodeException catch (e) {
      throw InvalidDataException('JSON decode error: ${e.message}');
    } on DataModelConversionException catch (e) {
      throw InvalidDataException(
        'Data model conversion error: ${e.message}',
        e,
      );
    } on GetPassException catch (e) {
      throw InternalErrorException('Failed to get path: ${e.message}');
    } on MissingDeckParameterException catch (e) {
      throw InvalidDataException(
        'Missing deck parameters: ${e.missingParameters.join(', ')}',
        e,
      );
    } on PermissionDeniedException catch (e) {
      throw PermissionRequiredException(
        'Permission denied for operation: ${e.message}',
        e,
      );
    } on DataSourceException catch (e) {
      throw DataAccessException('A data source error occurred', e);
    } catch (e) {
      throw InternalErrorException('An unexpected error occurred');
    }
  }
}
