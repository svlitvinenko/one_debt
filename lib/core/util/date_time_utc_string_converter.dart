import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeUtcStringConverter implements JsonConverter<DateTime, String> {
  const DateTimeUtcStringConverter();

  @override
  DateTime fromJson(String value) {
    return DateTime.parse(value).toLocal();
  }

  @override
  String toJson(DateTime date) => date.toUtc().toIso8601String();
}