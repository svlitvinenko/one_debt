// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

part 'd_user.freezed.dart';
part 'd_user.g.dart';

@freezed
class DUser with _$DUser {
  @JsonSerializable(explicitToJson: true)
  const factory DUser({
    @JsonKey(name: 'id', defaultValue: '') @Default('') String id,
    @JsonKey(name: 'name', defaultValue: '') @Default('') String name,
    @JsonKey(name: 'currency', defaultValue: 'USD') @Default('USD') String currency,
    @JsonKey(name: 'contacts', defaultValue: []) @Default([]) List<DContact> contacts,
    @JsonKey(name: 'incoming_debts', defaultValue: []) @Default([]) List<DDebt> incomingDebts,
    @JsonKey(name: 'outgoing_debts', defaultValue: []) @Default([]) List<DDebt> outgoingDebts,
  }) = _DUser;

  factory DUser.fromJson(Map<String, dynamic> json) => _$DUserFromJson(json);
}

extension DUserExtension on DUser {
  List<DDebt> debtsOfType(EDebtType type) => switch (type) {
        EDebtType.incoming => incomingDebts,
        EDebtType.outgoing => outgoingDebts,
      };
}
