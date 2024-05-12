import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/interactor.dart';

class Currency extends Interactor<String> {
  @override
  final ValueNotifier<String> model;

  Currency() : model = ValueNotifier('USD');

  @override
  Future<void> initialize() async {}

  @override
  bool get isInitialized => true;
  
  @override
  Future<void> clear() async {
    // no-op, currencies don't change from user to user
  }
}
