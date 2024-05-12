import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_bottom_safe_inset.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return DSScaffold(
      appBar: DSAppBar(
        title: Text(localizations.profileTitle),
      ),
      body: (context, constraints, layout) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            TextButton(
              onPressed: () {
                getDependency<Auth>().signOut();
              },
              child: Text('Sign out'),
            ),
            DSBottomSafeInset(),
          ],
        );
      },
    );
  }
}
