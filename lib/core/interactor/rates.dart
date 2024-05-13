import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/d_rate.dart';
import 'package:one_debt/core/model/d_rates.dart';
import 'package:one_debt/core/network/rates_network_service.dart';

class Rates extends Interactor<DRates?> {
  final RatesNetworkService _service;
  @override
  final ValueNotifier<DRates?> model;

  static const List<String> _kSupportedCurrencies = [
    'aed',
    'afn',
    'ars',
    'amd',
    'aud',
    'bdt',
    'bgn',
    'bhd',
    'bjf',
    'brl',
    'btn',
    'cad',
    'chf',
    'ckd',
    'cny',
    'cop',
    'cve',
    'dkk',
    'dzd',
    'egp',
    'eur',
    'fjd',
    'gbp',
    'ghs'
        'gwp',
    'hkd',
    'idr',
    'ils',
    'inr',
    'iqd',
    'jod',
    'jpy',
    'krw',
    'kwd',
    'lak',
    'lkr',
    'lrd',
    'lyd',
    'mad',
    'mdl',
    'mkd',
    'mlf',
    'mmk',
    'mop',
    'mru',
    'mvr',
    'mwk',
    'mxn',
    'myr',
    'mzn',
    'ngn',
    'nok',
    'npr',
    'nzd',
    'omr',
    'pgk',
    'php',
    'pkr',
    'pln',
    'qar',
    'ron',
    'rub',
    'sar',
    'sbd',
    'scr',
    'sek',
    'sgd',
    'std',
    'syp',
    'thb',
    'tnd',
    'try',
    'twd',
    'usd',
    'vnd',
    'wst',
    'xaf',
    'xof',
    'xpf',
    'yer',
    'zar',
  ];

  Rates({required RatesNetworkService service})
      : model = ValueNotifier(null),
        _service = service;

  @override
  Future<void> initialize() async {
    try {
      value = await _service.getRatesToUsd(_kSupportedCurrencies);
    } catch (e) {
      logger.e('Could not load rates', error: e);
    }
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
