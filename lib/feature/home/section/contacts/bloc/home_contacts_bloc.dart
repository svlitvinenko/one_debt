import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/interactor/rates.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_contact_summary.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/core/model/d_rates.dart';
import 'package:one_debt/core/model/d_user.dart';

part 'home_contacts_bloc.freezed.dart';

@freezed
class HomeContactsEvent with _$HomeContactsEvent {
  const factory HomeContactsEvent.initialize() = _Initialize;
}

@freezed
class HomeContactsState with _$HomeContactsState {
  const factory HomeContactsState.loading() = _Loading;
  const factory HomeContactsState.loaded({required List<DContactSummary> contacts}) = _Loaded;
}

class HomeContactsBloc extends Bloc<HomeContactsEvent, HomeContactsState> {
  HomeContactsBloc() : super(const HomeContactsState.loading()) {
    getDependency<Rates>().addListener(_onDataUpdated);
    getDependency<Auth>().addListener(_onDataUpdated);
    on<_Initialize>(_onInitialize, transformer: restartable());
  }

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<HomeContactsState> emit,
  ) async {
    final List<DContact> contacts = getDependency<Auth>().user?.contacts ?? [];
    final DUser? user = getDependency<Auth>().user;
    final DRates? rates = getDependency<Rates>().value;
    final String currency = getDependency<Auth>().user?.currency ?? 'USD';

    if (rates == null) return;
    if (user == null) return;

    final List<DContactSummary> result = List.empty(growable: true);

    for (final DContact contact in contacts) {
      final List<DDebt> incoming = user.incomingDebts.where((debt) => debt.contactId == contact.id).toList();
      final List<DDebt> outgoing = user.outgoingDebts.where((debt) => debt.contactId == contact.id).toList();

      final List<DDebt> incomingInTargetCurrency = incoming
          .map(
            (debt) => debt.copyWith(
              amount: DMoney(
                  cents: getDependency<Rates>().convertCents(
                        sourseCents: debt.amount.cents,
                        sourceIsoCode: debt.amount.isoCode,
                        targetIsoCode: currency,
                      ) ??
                      -1,
                  isoCode: currency),
            ),
          )
          .whereNot((element) => element.amount.cents.isNegative)
          .toList();

      if (incoming.isNotEmpty && incoming.length > incomingInTargetCurrency.length) {
        return;
      }

      final List<DDebt> outgoingInTargetCurrency = outgoing
          .map(
            (debt) => debt.copyWith(
              amount: DMoney(
                  cents: getDependency<Rates>().convertCents(
                        sourseCents: debt.amount.cents,
                        sourceIsoCode: debt.amount.isoCode,
                        targetIsoCode: currency,
                      ) ??
                      -1,
                  isoCode: currency),
            ),
          )
          .whereNot((element) => element.amount.cents.isNegative)
          .toList();

      if (outgoing.isNotEmpty && outgoing.length > outgoingInTargetCurrency.length) {
        return;
      }

      final DMoney incomingSum = incomingInTargetCurrency.isEmpty
          ? DMoney(cents: 0, isoCode: currency)
          : incomingInTargetCurrency.map((e) => e.amount).reduce(
                (value, element) => DMoney(cents: value.cents + element.cents, isoCode: currency),
              );
      final DMoney outgoingSum = outgoingInTargetCurrency.isEmpty
          ? DMoney(cents: 0, isoCode: currency)
          : outgoingInTargetCurrency.map((e) => e.amount).reduce(
                (value, element) => DMoney(cents: value.cents + element.cents, isoCode: currency),
              );

      if (incomingSum.cents > 0 || outgoingSum.cents > 0) {
        result.add(
          DContactSummary(
            contact: contact,
            currentIncoming: incomingSum,
            currentOutgoing: outgoingSum,
          ),
        );
      }
    }

    emit(HomeContactsState.loaded(contacts: result.toList()));
  }

  @override
  Future<void> close() {
    getDependency<Rates>().removeListener(_onDataUpdated);
    getDependency<Auth>().removeListener(_onDataUpdated);
    return super.close();
  }

  void _onDataUpdated() {
    add(const HomeContactsEvent.initialize());
  }
}
