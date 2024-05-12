import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/contacts.dart';
import 'package:one_debt/core/interactor/currency.dart';
import 'package:one_debt/core/interactor/debts.dart';
import 'package:one_debt/core/interactor/rates.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/e_debt_status.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

part 'debts_bloc.freezed.dart';

@freezed
class DebtsEvent with _$DebtsEvent {
  const factory DebtsEvent.initialize() = _Initialize;
}

@freezed
class DebtsState with _$DebtsState {
  const factory DebtsState.loading() = _Loading;
  const factory DebtsState.idle({required bool isLoading}) = _Idle;
  const factory DebtsState.setSummary({required List<DDebtSummary> summary}) = _SetSummary;
}

class DebtsBloc extends Bloc<DebtsEvent, DebtsState> {
  final EDebtType type;
  DebtsBloc({required this.type}) : super(const DebtsState.loading()) {
    getDependency<Rates>().addListener(_onDataUpdated);
    getDependency<Contacts>().addListener(_onDataUpdated);
    getDependency<Debts>().addListener(_onDataUpdated);
    getDependency<Currency>().addListener(_onDataUpdated);
    on<_Initialize>(_onInitialize, transformer: restartable());
  }

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<DebtsState> emit,
  ) async {
    emit(const DebtsState.idle(isLoading: true));
    final List<DDebt>? debts = getDependency<Debts>().value?.ofType(type);
    if (debts == null) return;

    final String localCurrency = getDependency<Currency>().value;

    final List<DDebtSummary> summary = List.empty(growable: true);

    for (final DDebt debt in debts) {
      final DMoney originalAmount = debt.amount;
      final DMoney? localAmount = getDependency<Rates>().convert(debt.amount, localCurrency);
      if (localAmount == null) continue;
      final DDebt localCurrencyDebt = debt.copyWith(amount: localAmount);
      final DContact? contact = getDependency<Contacts>().value.firstWhereOrNull(
            (element) => element.id == debt.contactId,
          );
      if (contact == null) continue;

      final EDebtStatus status = localCurrencyDebt.status;

      summary.add(DDebtSummary(
        debt: localCurrencyDebt,
        contact: contact,
        status: status,
        amountInOrigincalCurrency: originalAmount,
      ));
    }

    if (summary.length != debts.length) {
      return;
    }

    final List<DDebtSummary> sorted = summary.sortedBy<num>((element) => -element.debt.progress);

    emit(DebtsState.setSummary(summary: sorted.toList()));
    emit(const DebtsState.idle(isLoading: false));
  }

  @override
  Future<void> close() {
    getDependency<Rates>().removeListener(_onDataUpdated);
    getDependency<Contacts>().removeListener(_onDataUpdated);
    getDependency<Debts>().removeListener(_onDataUpdated);
    getDependency<Currency>().removeListener(_onDataUpdated);
    return super.close();
  }

  void _onDataUpdated() {
    add(const DebtsEvent.initialize());
  }
}
