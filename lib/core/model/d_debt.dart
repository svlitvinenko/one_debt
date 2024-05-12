// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/util/date_time_utc_string_converter.dart';

part 'd_debt.freezed.dart';
part 'd_debt.g.dart';

@freezed
class DDebt with _$DDebt {
  @JsonSerializable(explicitToJson: true)
  const factory DDebt({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'contact_id') required String contactId,
    @JsonKey(name: 'amount') required DMoney amount,
    @DateTimeUtcStringConverter() @JsonKey(name: 'created_at') required DateTime createdAt,
    @DateTimeUtcStringConverter() @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _DDebt;

  factory DDebt.fromJson(Map<String, dynamic> json) => _$DDebtFromJson(json);
}

extension DDebtExtension on DDebt {
  double get progress {
    final DateTime now = DateTime.now();

    if (now.isBefore(createdAt)) return 0.00;
    if (now.isAfter(expiresAt)) return 1;
    if (createdAt.isAfter(expiresAt) || createdAt.isAtSameMomentAs(expiresAt)) return 1;

    final int msNow = now.difference(createdAt).inMilliseconds;
    final int msEnd = expiresAt.difference(createdAt).inMilliseconds;

    final double progress = clampDouble(msNow / msEnd, 0.00, 1.00);

    return progress;
  }
}
