import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_auth_state.dart';
import 'package:one_debt/core/model/d_sign_in_result.dart';
import 'package:one_debt/core/model/d_sign_up_result.dart';
import 'package:one_debt/core/model/d_user.dart';
import 'package:one_debt/core/util/public_notifier.dart';
import 'package:one_debt/routes/app_route.dart';

class Auth extends Interactor<DAuthState?> {
  final FirebaseAuth firebase;
  @override
  final ValueNotifier<DAuthState?> model;

  bool get isSignedIn =>
      value?.mapOrNull(
        authorized: (_) => true,
      ) ==
      true;

  final PublicNotifier dataResetTrigger = PublicNotifier();

  Auth({required this.firebase}) : model = ValueNotifier(null);

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    firebase.authStateChanges().listen(_onAuthStateChanged);
    firebase.userChanges().listen(_onUserChanged);
    _onAuthStateChanged(firebase.currentUser);
    _onUserChanged(firebase.currentUser);
  }

  Future<DSignInResult> signIn(String email, String password) async {
    try {
      await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SuccessSignInResult();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return WrongCredentialsSignInResult();
        case 'user-not-found':
          return WrongCredentialsSignInResult();
        case 'invalid-email':
          return InvalidEmailSignInResult();
        case 'wrong-password':
          return WrongCredentialsSignInResult();
        default:
          return WrongCredentialsSignInResult();
      }
    } catch (e) {
      logger.e('Could not sign in', error: e);
      return FailureSignInResult();
    }
  }

  Future<DSignUpResult> signUp(String email, String password, String name) async {
    try {
      await firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebase.currentUser?.updateDisplayName(name);
      return SuccessSignUpResult();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return EmailAlreadyInUseSignUpResult();
        case 'invalid-email':
          return InvalidEmailSignUpResult();
        case 'weak-password':
          return WeakPasswordSignUpResult();
        default:
          rethrow;
      }
    } catch (e) {
      logger.e('Could not register', error: e);
      return FailureSignUpResult();
    }
  }

  Future<void> signOut() async {
    await firebase.signOut();
    value = null;
    dataResetTrigger.notify();
  }

  @override
  bool get isInitialized => model.value != null;

  @override
  Future<void> clear() async {
    value = null;
  }

  void _onAuthStateChanged(User? user) {
    if (user != null) {

      model.value = DAuthState.authorized(
          user: DUser(
        id: user.uid,
        name: user.displayName ?? '',
      ));
    } else {
      model.value = const DAuthState.unauthorized();
      routes.replaceAll(const AuthenticationRoute());
    }
  }

  void _onUserChanged(User? user) {
    if (user != null) {
      model.value = DAuthState.authorized(
          user: DUser(
        id: user.uid,
        name: user.displayName ?? '',
      ));

    }
  }
}
