import 'package:flutter/material.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/routes/app_route.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DSScaffold(
      body: (context, constraints, layout) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('404'),
            const Text('Page not found'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                routes.replaceAll(const HomeRoute());
              },
              child: const Text('Return to home page'),
            ),
          ],
        );
      },
    );
  }
}
