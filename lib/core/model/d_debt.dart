import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_money.dart';

part 'd_debt.freezed.dart';

@freezed
class DDebt with _$DDebt {
  const factory DDebt({
    required String id,
    required String contactId,
    required DMoney amount,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _DDebt;
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
