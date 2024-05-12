import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/feature/authentication/bloc/authentication_bloc.dart';
import 'package:one_debt/feature/authentication/widgets/app_version_tile.dart';
import 'package:one_debt/routes/app_route.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final ValueNotifier<bool> isLoadingController;
  late final ValueNotifier<bool> isSignUpModeController;

  late final TextEditingController emailTextController;
  late final ValueNotifier<String> emailController;
  late final ValueNotifier<String?> emailErrorController;

  late final TextEditingController passwordTextController;
  late final ValueNotifier<String> passwordController;
  late final ValueNotifier<String?> passwordErrorController;

  late final TextEditingController nameTextController;
  late final ValueNotifier<String> nameController;
  late final ValueNotifier<String?> nameErrorController;

  @override
  void initState() {
    isLoadingController = ValueNotifier(true);
    isSignUpModeController = ValueNotifier(false);
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    nameTextController = TextEditingController();
    emailController = ValueNotifier('');
    emailErrorController = ValueNotifier(null);
    passwordController = ValueNotifier('');
    passwordErrorController = ValueNotifier(null);
    nameController = ValueNotifier('');
    nameErrorController = ValueNotifier(null);

    emailTextController.addListener(onEmailTextChanged);
    emailController.addListener(onEmailChanged);
    passwordTextController.addListener(onPasswordTextChanged);
    passwordController.addListener(onPasswordChanged);
    nameTextController.addListener(onNameTextChanged);
    nameController.addListener(onNameChanged);
    super.initState();
  }

  @override
  void dispose() {
    isLoadingController.dispose();
    isSignUpModeController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    nameTextController.dispose();
    emailController.dispose();
    emailErrorController.dispose();
    passwordController.dispose();
    passwordErrorController.dispose();
    nameController.dispose();
    nameErrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(const AuthenticationEvent.initialized()),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          state.map(
            loading: (state) {
              isLoadingController.value = true;
            },
            loaded: (state) {
              isLoadingController.value = state.isLoading;
            },
            showAuthenticateSuccess: (state) {
              TextInput.finishAutofillContext(shouldSave: true);
              routes.replaceAll(const HomeRoute());
            },
            showWrongCredentialsFailure: (state) {
              passwordErrorController.value = 'Wrong email or password';
            },
            showInvalidEmailFailure: (state) {
              emailErrorController.value = 'Invalid email';
            },
            showOtherFailure: (state) {
              emailErrorController.value = 'An error occured';
            },
            showSignUpEmailAlreadyInUseFailure: (state) {
              emailErrorController.value = 'This email is already in use';
            },
            showSignUpWeakPasswordFailure: (state) {
              passwordErrorController.value = 'This password is too weak';
            },
            showSignUpOtherFailure: (state) {
              emailErrorController.value = 'An error occured';
            },
            showSignUpInvalidEmailFailure: (state) {
              emailErrorController.value = 'Invalid email';
            },
            setSignUpMode: (state) {
              isSignUpModeController.value = state.isEnabled;
            },
          );
        },
        child: DSScaffold(
          body: (context, constraints, layout) {
            return Stack(
              children: [
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AppVersionTile(),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0, 0.5),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: AutofillGroup(
                        child: DSCard(
                          title: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Sign in',
                                    style: context.textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ValueListenableBuilder<bool>(
                                    valueListenable: isLoadingController,
                                    builder: (context, isLoading, _) {
                                      return ValueListenableBuilder<bool>(
                                        valueListenable: isSignUpModeController,
                                        builder: (context, isSignUpMode, _) {
                                          final bool isEnabled = !isLoading;
                                          return TextButton(
                                            onPressed: !isEnabled
                                                ? null
                                                : isSignUpMode
                                                    ? () {
                                                        isSignUpModeController.value = false;
                                                      }
                                                    : () {
                                                        isSignUpModeController.value = true;
                                                      },
                                            child: Text(
                                              isSignUpMode ? 'Sign in instead' : 'Sign up instead',
                                              style: context.textTheme.labelMedium,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder<bool>(
                                  valueListenable: isLoadingController,
                                  builder: (context, isLoading, _) {
                                    final bool isEnabled = !isLoading;
                                    return ValueListenableBuilder<String?>(
                                      valueListenable: emailErrorController,
                                      builder: (context, error, _) {
                                        return TextField(
                                          autofillHints: const [AutofillHints.email],
                                          enabled: isEnabled,
                                          controller: emailTextController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            errorMaxLines: 2,
                                            errorText: error,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              const SizedBox(height: 8),
                              ValueListenableBuilder<bool>(
                                  valueListenable: isSignUpModeController,
                                  builder: (context, isSignUpMode, _) {
                                    return ValueListenableBuilder<bool>(
                                        valueListenable: isLoadingController,
                                        builder: (context, isLoading, _) {
                                          final bool isEnabled = !isLoading;
                                          return ValueListenableBuilder<String?>(
                                            valueListenable: passwordErrorController,
                                            builder: (context, error, _) {
                                              return TextField(
                                                autofillHints: [
                                                  isSignUpMode ? AutofillHints.newPassword : AutofillHints.password
                                                ],
                                                enabled: isEnabled,
                                                textInputAction:
                                                    isSignUpMode ? TextInputAction.next : TextInputAction.done,
                                                keyboardType: TextInputType.visiblePassword,
                                                obscureText: true,
                                                controller: passwordTextController,
                                                onSubmitted: isSignUpMode ? null : (_) => onSignInPressed(context),
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  errorMaxLines: 2,
                                                  errorText: error,
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  }),
                              ValueListenableBuilder<bool>(
                                  valueListenable: isLoadingController,
                                  builder: (context, isLoading, _) {
                                    return ValueListenableBuilder<bool>(
                                        valueListenable: isSignUpModeController,
                                        builder: (context, isSignUpMode, _) {
                                          return AnimatedOpacity(
                                            opacity: isSignUpMode ? 1.00 : 0.00,
                                            duration: context.times.fastest,
                                            child: AnimatedSize(
                                              key: const ValueKey('name_section'),
                                              duration: context.times.fastest,
                                              alignment: Alignment.topCenter,
                                              curve: Curves.easeOutCubic,
                                              child: isSignUpMode
                                                  ? Column(
                                                      key: const ValueKey('name_shown'),
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        const SizedBox(height: 8),
                                                        ValueListenableBuilder<bool>(
                                                          valueListenable: isSignUpModeController,
                                                          builder: (context, isSignUpMode, _) {
                                                            return ValueListenableBuilder<String?>(
                                                              valueListenable: nameErrorController,
                                                              builder: (context, error, _) {
                                                                final bool isEnabled = isSignUpMode && !isLoading;
                                                                return TextField(
                                                                  autofillHints: const [AutofillHints.name],
                                                                  enabled: isEnabled,
                                                                  controller: nameTextController,
                                                                  textInputAction: TextInputAction.done,
                                                                  onSubmitted: (_) => onSignUpPressed(context),
                                                                  decoration: InputDecoration(
                                                                    labelText: 'Display name',
                                                                    errorMaxLines: 2,
                                                                    errorText: error,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  : const Column(
                                                      key: ValueKey('name_hidden'),
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        SizedBox.shrink(),
                                                      ],
                                                    ),
                                            ),
                                          );
                                        });
                                  }),
                              const Spacer(),
                              const SizedBox(height: 16),
                              ListenableBuilder(
                                listenable: Listenable.merge([
                                  emailErrorController,
                                  passwordErrorController,
                                  nameErrorController,
                                ]),
                                builder: (context, child) {
                                  return ValueListenableBuilder<bool>(
                                      valueListenable: isLoadingController,
                                      builder: (context, isLoading, _) {
                                        return ValueListenableBuilder<bool>(
                                          valueListenable: isSignUpModeController,
                                          builder: (context, isSignUpMode, _) {
                                            final bool isEnabled = !isLoading &&
                                                emailErrorController.value == null &&
                                                passwordErrorController.value == null &&
                                                (!isSignUpMode || nameErrorController.value == null);
                                            return FilledButton(
                                              onPressed: isEnabled
                                                  ? () {
                                                      if (isSignUpMode) {
                                                        onSignUpPressed(context);
                                                      } else {
                                                        onSignInPressed(context);
                                                      }
                                                    }
                                                  : null,
                                              child: Text(isSignUpMode ? 'Sign up' : 'Sign in'),
                                            );
                                          },
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void onEmailTextChanged() {
    emailController.value = emailTextController.text.trim();
  }

  void onEmailChanged() {
    emailErrorController.value = null;
  }

  void onPasswordTextChanged() {
    passwordController.value = passwordTextController.text.trim();
  }

  void onPasswordChanged() {
    passwordErrorController.value = null;
  }

  void onNameTextChanged() {
    nameController.value = nameTextController.text.trim();
  }

  void onNameChanged() {
    nameErrorController.value = null;
  }

  void onSignUpPressed(BuildContext context) {
    context.read<AuthenticationBloc>().add(
          AuthenticationEvent.signUpByEmailPassword(
            email: emailController.value,
            password: passwordController.value,
            name: nameController.value,
          ),
        );
  }

  void onSignInPressed(BuildContext context) {
    context.read<AuthenticationBloc>().add(
          AuthenticationEvent.signInByEmailPassword(
            email: emailController.value,
            password: passwordController.value,
          ),
        );
  }
}
