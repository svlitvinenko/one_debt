import 'package:one_debt/core/model/d_debt.dart';

enum EDebtStatus {
  active,
  expiresSoon,
  expired,
}

extension DDebtStatusExtension on DDebt {
  EDebtStatus get status {
    final DateTime now = DateTime.now();
    if (now.isAfter(expiresAt)) return EDebtStatus.expired;
    if (now.difference(expiresAt) > const Duration(days: 7)) return EDebtStatus.expiresSoon;
    return EDebtStatus.active;
  }
}
