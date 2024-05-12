import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_rate.dart';

part 'd_rates.freezed.dart';

@freezed
class DRates with _$DRates {
  const factory DRates({
    required List<DRate> rates,
  }) = _DRates;
  const DRates._();

  double? getRateToUsd(String isoCode) {
    return rates.firstWhereOrNull((element) => element.isoCode == isoCode)?.toUsd;
  }
}
