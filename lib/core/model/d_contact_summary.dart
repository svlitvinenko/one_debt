import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_money.dart';

part 'd_contact_summary.freezed.dart';

@freezed
class DContactSummary with _$DContactSummary {
  const factory DContactSummary({
    required DContact contact,
    required DMoney currentIncoming,
    required DMoney currentOutgoing,
  }) = _DContactSummary;
}
