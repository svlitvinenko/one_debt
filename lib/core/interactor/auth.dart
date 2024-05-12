import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDataSubscription;
  @override
  final ValueNotifier<DAuthState?> model;

  bool get isSignedIn =>
      value?.mapOrNull(
        authorized: (_) => true,
      ) ==
      true;

  final PublicNotifier dataResetTrigger = PublicNotifier();

  Auth({required this.auth, required this.firestore}) : model = ValueNotifier(null);

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    auth.authStateChanges().listen(_onAuthStateChanged);
    auth.userChanges().listen(_onUserChanged);
    _onAuthStateChanged(auth.currentUser);
    _onUserChanged(auth.currentUser);
  }

  Future<DSignInResult> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
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
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth.currentUser?.updateDisplayName(name);
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
    await auth.signOut();
    value = null;
    dataResetTrigger.notify();
  }

  @override
  bool get isInitialized => model.value != null;

  DUser? get user => value?.mapOrNull(authorized: (value) => value.user);

  @override
  Future<void> clear() async {
    value = null;
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user != null) {
    } else {
      model.value = const DAuthState.unauthorized();
      routes.replaceAll(const AuthenticationRoute());
    }
  }

  Future<void> _onUserChanged(User? user) async {
    if (user != null) {
      _userDataSubscription?.cancel();
      _userDataSubscription = firestore.collection('users').doc(user.uid).snapshots().listen(_onUserDataChanged);
    }
  }

  Future<void> _onUserDataChanged(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final User? firebaseUser = auth.currentUser;
    if (firebaseUser == null) return;

    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) {
      final DUser user = DUser(
        id: snapshot.id,
        name: firebaseUser.displayName ?? '',
        currency: 'USD',
        contacts: [],
        incomingDebts: [],
        outgoingDebts: [],
      );
      await firestore.collection('users').doc(user.id).set(
            user.toJson(),
            SetOptions(merge: true),
          );
      value = DAuthState.authorized(user: user);
    } else {
      final DUser user = DUser.fromJson(data).copyWith(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
      );
      value = DAuthState.authorized(user: user);
    }
  }
}
