import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_rate.freezed.dart';

@freezed
class DRate with _$DRate {
  const factory DRate({required String isoCode, required double toUsd}) = _DRate;
}
