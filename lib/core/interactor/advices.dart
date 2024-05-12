import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/auth.dart';

import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_advice.dart';
import 'package:one_debt/core/model/d_debt.dart';

class Advices extends Interactor<List<DAdvice>?> {
  final Auth auth;

  Advices({required this.auth}) : model = ValueNotifier(null) {
    auth.addListener(onDataChanged);
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
    final List<DDebt> incomingDebts = auth.user?.incomingDebts ?? [];
    final List<DDebt> outgoingDebts = auth.user?.outgoingDebts ?? [];
  }
}
