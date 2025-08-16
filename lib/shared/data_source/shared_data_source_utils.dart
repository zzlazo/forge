import 'dart:convert';

import 'data_source_exception.dart';

class SharedDataSourceUtils {
  static T wrapParseJsonToModel<T>(T Function() fromJsonCallback) {
    try {
      final T model = fromJsonCallback();
      return model;
    } on TypeError catch (e) {
      throw DataModelConversionException(
        T.toString(),
        'Type error during model conversion: ${e.toString()}',
      );
    } on FormatException catch (e) {
      throw JsonDecodeException(
        e.source?.toString() ?? 'Unknown JSON content',
        e.message,
      );
    } catch (e) {
      throw UnexpectedParsingException(
        'An unexpected error occurred during JSON parsing for model ${T.toString()}: ${e.toString()}',
        e,
      );
    }
  }

  static T wrapJsonDecode<T>(String jsonString, String debugSource) {
    try {
      return jsonDecode(jsonString) as T;
    } on FormatException catch (e) {
      throw JsonDecodeException(jsonString, e.message);
    } on TypeError catch (e) {
      throw DataModelConversionException(
        T.toString(),
        'Type error after JSON decoding for source "$debugSource": ${e.toString()}',
      );
    } catch (e) {
      throw UnexpectedParsingException(
        'An unexpected error occurred during JSON decoding for source "$debugSource": ${e.toString()}',
        e,
      );
    }
  }
}
