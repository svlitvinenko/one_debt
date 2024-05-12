import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/d_rate.dart';
import 'package:one_debt/core/model/d_rates.dart';

class Rates extends Interactor<DRates?> {
  @override
  final ValueNotifier<DRates?> model;

  Rates() : model = ValueNotifier(null);

  @override
  Future<void> initialize() async {
    model.value = const DRates(
      rates: [
        DRate(isoCode: 'USD', toUsd: 1),
        DRate(isoCode: 'RUB', toUsd: 97.1),
        DRate(isoCode: 'ARS', toUsd: 1024.67),
        DRate(isoCode: 'TRY', toUsd: 33.21),
      ],
    );
  }

  @override
  bool get isInitialized => model.value != null;

  int? convertCents({
    required int sourseCents,
    required String sourceIsoCode,
    required String targetIsoCode,
  }) {
    final DRate? sourceRate = value?.rates.firstWhereOrNull((rate) => rate.isoCode == sourceIsoCode);
    if (sourceRate == null) return null;

    final DRate? targetRate = value?.rates.firstWhereOrNull((rate) => rate.isoCode == targetIsoCode);
    if (targetRate == null) return null;

    final double centsInUsd = sourseCents / sourceRate.toUsd;
    final double centsInTarget = centsInUsd * targetRate.toUsd;

    return centsInTarget.floor();
  }

  DMoney? convert(DMoney source, String targetIsoCode) {
    final int? targetCents = convertCents(
      sourseCents: source.cents,
      sourceIsoCode: source.isoCode,
      targetIsoCode: targetIsoCode,
    );
    if (targetCents == null) return null;
    return DMoney(
      cents: targetCents,
      isoCode: targetIsoCode,
    );
  }

  @override
  Future<void> clear() async {
    // no-op, rates don't change from user to user
  }
}
