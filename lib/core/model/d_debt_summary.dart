import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/e_debt_status.dart';

part 'd_debt_summary.freezed.dart';

@freezed
class DDebtSummary with _$DDebtSummary {
  const factory DDebtSummary({
    required DMoney amountInOrigincalCurrency,
    required DDebt debt,
    required DContact contact,
    required EDebtStatus status,
  }) = _DDebtSummary;
}
