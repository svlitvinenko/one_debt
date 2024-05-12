import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/model/d_sign_in_result.dart';
import 'package:one_debt/core/model/d_sign_up_result.dart';
import 'package:one_debt/routes/app_route.dart';

part 'authentication_bloc.freezed.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.initialized() = _Initialized;
  const factory AuthenticationEvent.signInByEmailPassword({
    required String email,
    required String password,
  }) = _SignInByEmailPassword;

  const factory AuthenticationEvent.signUpByEmailPassword({
    required String email,
    required String password,
    required String name,
  }) = _SignUpByEmailPassword;
}

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.loading() = _Loading;
  const factory AuthenticationState.loaded({required bool isLoading}) = _Loaded;
  const factory AuthenticationState.showAuthenticateSuccess() = _ShowAuthenticateSuccess;
  const factory AuthenticationState.showWrongCredentialsFailure() = _ShowWrongCredentialsFailure;
  const factory AuthenticationState.showInvalidEmailFailure() = _ShowInvalidEmailFailure;
  const factory AuthenticationState.showOtherFailure() = _ShowOtherFailure;
  const factory AuthenticationState.showSignUpEmailAlreadyInUseFailure() = _ShowSignUpEmailAlreadyInUseFailure;
  const factory AuthenticationState.showSignUpWeakPasswordFailure() = _ShowSignUpWeakPasswordFailure;
  const factory AuthenticationState.showSignUpOtherFailure() = _ShowSignUpOtherFailure;
  const factory AuthenticationState.showSignUpInvalidEmailFailure() = _ShowSignUpInvalidEmailFailure;
  const factory AuthenticationState.setSignUpMode({required bool isEnabled}) = _SetSignUpMode;
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.loading()) {
    on<_Initialized>(_onInitialized);
    on<_SignInByEmailPassword>(_onSignInByEmailPassword);
    on<_SignUpByEmailPassword>(_onSignUpByEmailPassword);
  }

  Auth get _auth => getDependency();

  FutureOr<void> _onInitialized(
    _Initialized event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loading());
    await _auth.waitForInitialization();
    if (_auth.isSignedIn) {
      routes.replaceAll(const HomeRoute());
      return;
    }
    emit(const AuthenticationState.loaded(isLoading: false));
  }

  FutureOr<void> _onSignInByEmailPassword(
    _SignInByEmailPassword event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loaded(isLoading: true));
    final DSignInResult result = await _auth.signIn(event.email, event.password);
    switch (result) {
      case SuccessSignInResult():
        emit(const AuthenticationState.showAuthenticateSuccess());
        emit(const AuthenticationState.loaded(isLoading: true));
        return;
      case WrongCredentialsSignInResult():
        emit(const AuthenticationState.showWrongCredentialsFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
      case FailureSignInResult():
        emit(const AuthenticationState.showOtherFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
      case InvalidEmailSignInResult():
        emit(const AuthenticationState.showInvalidEmailFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
    }
  }

  FutureOr<void> _onSignUpByEmailPassword(
    _SignUpByEmailPassword event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loaded(isLoading: true));
    final DSignUpResult result = await _auth.signUp(event.email, event.password, event.name);
    switch (result) {
      case SuccessSignUpResult():
        emit(const AuthenticationState.showAuthenticateSuccess());
        emit(const AuthenticationState.loaded(isLoading: true));
        return;
      case EmailAlreadyInUseSignUpResult():
        emit(const AuthenticationState.showSignUpEmailAlreadyInUseFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
      case WeakPasswordSignUpResult():
        emit(const AuthenticationState.showSignUpWeakPasswordFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
      case FailureSignUpResult():
        emit(const AuthenticationState.showSignUpOtherFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
      case InvalidEmailSignUpResult():
        emit(const AuthenticationState.showSignUpInvalidEmailFailure());
        emit(const AuthenticationState.loaded(isLoading: false));
        return;
    }
  }
}
