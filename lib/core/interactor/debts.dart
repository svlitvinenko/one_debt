import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/d_debts.dart';
import 'package:one_debt/core/model/d_money.dart';

class Debts extends Interactor<DDebts?> {
  @override
  final ValueNotifier<DDebts?> model;

  static final DDebts _kDebts = DDebts(
      outgoing: [],
      incoming: [
        DDebt(
          id: '1',
          contactId: '1',
          amount: const DMoney(cents: 100000, isoCode: 'ARS'),
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(
            const Duration(days: 30),
          ),
        ),
        DDebt(
          id: '2',
          contactId: '1',
          amount: const DMoney(cents: 1500000, isoCode: 'RUB'),
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(
            const Duration(days: 10),
          ),
        ),
        DDebt(
          id: '5',
          contactId: '1',
          amount: const DMoney(cents: 300000, isoCode: 'TRY'),
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().subtract(
            const Duration(days: 5),
          ),
        ),
        DDebt(
          id: '3',
          contactId: '1',
          amount: const DMoney(cents: 300000, isoCode: 'TRY'),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          expiresAt: DateTime.now().add(
            const Duration(minutes: 5),
          ),
        ),
        DDebt(
          id: '4',
          contactId: '1',
          amount: const DMoney(cents: 300000, isoCode: 'TRY'),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          expiresAt: DateTime.now().add(
            const Duration(minutes: 1),
          ),
        ),
      ],
    );

  Debts() : model = ValueNotifier(null);

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    model.value = _kDebts;
  }

  @override
  bool get isInitialized => model.value != null;

  @override
  Future<void> clear() async {
    value = null;
  }
}
