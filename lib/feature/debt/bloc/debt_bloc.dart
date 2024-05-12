import 'dart:async';

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

part 'debt_bloc.freezed.dart';

@freezed
class DebtEvent with _$DebtEvent {
  const factory DebtEvent.initialized() = _Initialized;
}

@freezed
class DebtState with _$DebtState {
  const factory DebtState.loading() = _Loading;
  const factory DebtState.idle({required bool isLoading}) = _Idle;
  const factory DebtState.setDebtSummary({required DDebtSummary debt}) = _SetDebtSummary;
}

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final EDebtType type;
  final String id;
  DebtBloc({required this.type, required this.id}) : super(const DebtState.loading()) {
    getDependency<Rates>().addListener(_onDataUpdated);
    getDependency<Contacts>().addListener(_onDataUpdated);
    getDependency<Debts>().addListener(_onDataUpdated);
    getDependency<Currency>().addListener(_onDataUpdated);
    on<_Initialized>(_onInitialized);
  }

  FutureOr<void> _onInitialized(_Initialized event, Emitter<DebtState> emit) async {
    final List<DDebt>? debts = getDependency<Debts>().value?.ofType(type);
    if (debts == null) return;
    final debt = debts.firstWhereOrNull((element) => element.id == id);
    if (debt == null) return;

    final String localCurrency = getDependency<Currency>().value;

    final DMoney originalAmount = debt.amount;
    final DMoney? localAmount = getDependency<Rates>().convert(debt.amount, localCurrency);
    if (localAmount == null) return;
    final DDebt localCurrencyDebt = debt.copyWith(amount: localAmount);
    final DContact? contact = getDependency<Contacts>().value.firstWhereOrNull(
          (element) => element.id == debt.contactId,
        );
    if (contact == null) return;

    final EDebtStatus status = localCurrencyDebt.status;

    final DDebtSummary summary = DDebtSummary(
      debt: localCurrencyDebt,
      contact: contact,
      status: status,
      amountInOrigincalCurrency: originalAmount,
    );

    emit(DebtState.setDebtSummary(debt: summary));
    emit(const DebtState.idle(isLoading: false));
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
    add(const DebtEvent.initialized());
  }
}
