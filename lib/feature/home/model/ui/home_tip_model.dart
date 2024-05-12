import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

part 'home_tip_model.freezed.dart';

@freezed
class HomeTipModel with _$HomeTipModel {
  const factory HomeTipModel({
    required String title,
    required String description,
    required HomeTipType type,
  }) = _HomeTipModel;
}

enum HomeTipType {
  neutral,
  incoming,
  outgoing;

  EDebtType? get debtType => switch (this) {
        HomeTipType.neutral => null,
        HomeTipType.incoming => EDebtType.incoming,
        HomeTipType.outgoing => EDebtType.outgoing,
      };
}
