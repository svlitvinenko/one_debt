import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

part 'd_debts.freezed.dart';

@freezed
class DDebts with _$DDebts {
  const factory DDebts({
    required List<DDebt> outgoing,
    required List<DDebt> incoming,
  }) = _DDebts;
  const DDebts._();

  List<DDebt> ofType(EDebtType type) => switch (type) {
        EDebtType.incoming => incoming,
        EDebtType.outgoing => outgoing,
      };
}
