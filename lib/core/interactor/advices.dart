import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/contacts.dart';
import 'package:one_debt/core/interactor/debts.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_advice.dart';
import 'package:one_debt/core/model/d_contact.dart';
import 'package:one_debt/core/model/d_debts.dart';

class Advices extends Interactor<List<DAdvice>?> {
  final Debts debts;
  final Contacts contacts;

  Advices({required this.debts, required this.contacts}) : model = ValueNotifier(null) {
    debts.addListener(onDataChanged);
    contacts.addListener(onDataChanged);
  }

  @override
  Future<void> clear() async {
    value = null;
  }

  @override
  Future<void> initialize() async {}

  @override
  bool get isInitialized => true;

  @override
  final ValueNotifier<List<DAdvice>?> model;

  void onDataChanged() {
    final DDebts? debts = this.debts.value;
    final List<DContact> contacts = this.contacts.value;

    
  }
}
