import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class Interactor<T> implements ValueNotifier<T> {
  ValueNotifier<T> get model;

  @override
  T get value => model.value;

  Future<void> initialize();

  Future<void> clear();

  bool get isInitialized;

  Future<void> waitForInitialization() async {
    if (isInitialized) {
      return;
    }

    final Completer completer = Completer();

    void onModelChanged() {
      if (isInitialized) {
        completer.complete();
      }
    }

    model.addListener(onModelChanged);
    await completer.future;
    model.removeListener(onModelChanged);
  }

  @override
  void addListener(VoidCallback listener) {
    model.addListener(listener);
  }

  @override
  void dispose() {
    model.dispose();
  }

  @override
  bool get hasListeners => model.hasListeners;

  @override
  void notifyListeners() {
    model.notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener) {
    model.removeListener(listener);
  }

  @override
  set value(T newValue) {
    model.value = newValue;
  }
}
