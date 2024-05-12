// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_money.freezed.dart';
part 'd_money.g.dart';

@freezed
class DMoney with _$DMoney {
  const factory DMoney({
    @JsonKey(name: 'cents') required int cents,
    @JsonKey(name: 'iso_code') required String isoCode,
  }) = _DMoney;
  const DMoney._();

  factory DMoney.fromJson(Map<String, dynamic> json) => _$DMoneyFromJson(json);

  @override
  String toString() {
    return '${(cents / 100).toStringAsFixed(2)} $isoCode';
  }
}
