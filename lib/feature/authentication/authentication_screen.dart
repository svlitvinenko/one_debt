import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/feature/authentication/bloc/authentication_bloc.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign in',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const TextField(),
                  const SizedBox(height: 8),
                  const TextField(),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                            const AuthenticationEvent.authenticateByEmailPassword(
                              email: 'example@email.com',
                              password: 'password',
                            ),
                          );
                    },
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
