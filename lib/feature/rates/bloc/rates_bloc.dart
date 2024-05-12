import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/interactor/rates.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/d_rate.dart';
import 'package:one_debt/core/model/d_rates.dart';
import 'package:one_debt/core/model/d_user.dart';

part 'rates_bloc.freezed.dart';

@freezed
class RatesEvent with _$RatesEvent {
  const factory RatesEvent.initialized() = _Initialized;
  const factory RatesEvent.updatePrimaryCurrency() = _UpdatePrimaryCurrency;
}

@freezed
class RatesState with _$RatesState {
  const factory RatesState.loading() = _Loading;
  const factory RatesState.idle({
    required bool isEnabled,
    required List<DMoney> convertedRates,
    required String isoCode,
  }) = _Idle;
}

class RatesBloc extends Bloc<RatesEvent, RatesState> {
  final Rates rates = getDependency();
  final Auth auth = getDependency();

  RatesBloc() : super(const RatesState.loading()) {
    rates.addListener(_onDataChanged);
    auth.addListener(_onDataChanged);
    on<_Initialized>(_onInitialized);
    on<_UpdatePrimaryCurrency>(_onUpdatePrimaryCurrency);
  }

  @override
  Future<void> close() {
    rates.removeListener(_onDataChanged);
    auth.removeListener(_onDataChanged);
    return super.close();
  }

  FutureOr<void> _onInitialized(_Initialized event, Emitter<RatesState> emit) async {
    emit(const RatesState.loading());
    final DRates? rates = this.rates.value;
    final DUser? user = auth.user;

    if (rates == null) return;
    if (user == null) return;

    final List<DMoney> convertedRates = rates.rates
        .map((e) => e.isoCode)
        .map(
          (String isoCode) => DMoney(
            cents: this.rates.convertCents(sourseCents: 100, sourceIsoCode: 'USD', targetIsoCode: isoCode)!,
            isoCode: isoCode,
          ),
        )
        .toList();
    emit(RatesState.idle(convertedRates: convertedRates, isoCode: user.currency, isEnabled: true));
  }

  FutureOr<void> _onUpdatePrimaryCurrency(_UpdatePrimaryCurrency event, Emitter<RatesState> emit) {}

  void _onDataChanged() {
    add(const RatesEvent.initialized());
  }
}
