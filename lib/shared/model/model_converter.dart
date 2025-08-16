import 'package:json_annotation/json_annotation.dart';

class Rfc3339DateTimeConverter implements JsonConverter<DateTime, String> {
  const Rfc3339DateTimeConverter();

  @override
  DateTime fromJson(String? json) {
    if (json == null || json.isEmpty) {
      throw FormatException('Invalid DateTime format: null or empty string');
    }
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
