import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/model/d_auth_state.dart';

part 'authentication_bloc.freezed.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.initialized() = _Initialized;
  const factory AuthenticationEvent.authenticateByEmailPassword({
    required String email,
    required String password,
  }) = _AuthenticateByEmailPassword;
}

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.loading() = _Loading;
  const factory AuthenticationState.unauthenticated() = _Unauthenticated;
  const factory AuthenticationState.authenticated() = _Authenticated;
  const factory AuthenticationState.showAuthenticateSuccess() = _ShowAuthenticateSuccess;
  const factory AuthenticationState.showAuthenticateFailure() = _ShowAuthenticateFailure;
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.loading()) {
    on<_Initialized>(_onInitialized);
    on<_AuthenticateByEmailPassword>(_onAuthenticateByEmailPassword);
  }

  Auth get _auth => getDependency();

  FutureOr<void> _onInitialized(
    _Initialized event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loading());
    await _auth.waitForInitialization();
    final AuthenticationState state = _auth.model.value?.map(
          unauthorized: (_) => const AuthenticationState.unauthenticated(),
          authorized: (s) => const AuthenticationState.authenticated(),
        ) ??
        const AuthenticationState.unauthenticated();
    emit(state);
  }

  FutureOr<void> _onAuthenticateByEmailPassword(
    _AuthenticateByEmailPassword event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _auth.signIn(event.email, event.password);
    final DAuthState? authState = _auth.value;
    if (authState != null) {
      emit(const AuthenticationState.showAuthenticateSuccess());
      emit(const AuthenticationState.authenticated());
    }
  }
}
