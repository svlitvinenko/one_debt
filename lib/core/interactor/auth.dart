import 'package:flutter/foundation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_auth_state.dart';
import 'package:one_debt/core/model/d_user.dart';
import 'package:one_debt/core/util/public_notifier.dart';
import 'package:one_debt/routes/app_route.dart';

class Auth extends Interactor<DAuthState?> {
  @override
  final ValueNotifier<DAuthState?> model;

  bool get isSignedIn =>
      value?.mapOrNull(
        authorized: (_) => true,
      ) ==
      true;

  final PublicNotifier dataResetTrigger = PublicNotifier();

  Auth() : model = ValueNotifier(null);

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    model.value = const DAuthState.unauthorized();
    routes.replaceAll(const AuthenticationRoute());
  }

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final DAuthState state = DAuthState.authorized(user: DUser(id: '1', name: 'Borislav'));
    model.value = state;
    routes.replaceAll(const HomeRoute());
  }

  Future<void> signOut() async {
    value = null;
    dataResetTrigger.notify();
  }

  @override
  bool get isInitialized => model.value != null;

  @override
  Future<void> clear() async {
    value = null;
  }
}
