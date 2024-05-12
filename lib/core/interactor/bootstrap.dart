import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/e_bootstrap_state.dart';

class Bootstrap extends Interactor<EBootstrapState> {
  Bootstrap({required this.auth, required List<Interactor> interactors})
      : model = ValueNotifier(EBootstrapState.loading),
        _primaryInteractors = interactors.toList() {
    auth.dataResetTrigger.addListener(onDataReset);
  }

  final List<Interactor> _primaryInteractors;
  final Auth auth;
  @override
  final ValueNotifier<EBootstrapState> model;

  @override
  Future<void> initialize() async {
    model.value = EBootstrapState.loading;
    for (final interactor in _primaryInteractors) {
      await interactor.initialize();
    }
    model.value = EBootstrapState.loaded;
  }

  @override
  bool get isInitialized => model.value == EBootstrapState.loaded;

  @override
  Future<void> clear() async {
    for (final interactor in _primaryInteractors) {
      await interactor.clear();
    }
  }

  Future<void> onDataReset() async {
    await clear();
    await initialize();
  }
}
