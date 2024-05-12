import 'package:flutter/material.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/components/ds_debt_type_theme.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/core/model/d_auth_state.dart';
import 'package:one_debt/core/model/d_user.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

class HomeDebtsSection extends StatelessWidget {
  final EDebtType type;
  final void Function() onTap;
  const HomeDebtsSection({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return DSDebtTypeTheme(
      type: type,
      builder: (context) {
        return DSCard(
          isPrimaryContainerColored: true,
          title: Text(
            switch (type) {
              EDebtType.incoming => localizations.incomingDebtsTitle,
              EDebtType.outgoing => localizations.outgoingDebtsTitle,
            },
          ),
          onTap: onTap,
          child: ValueListenableBuilder<DAuthState?>(
            valueListenable: getDependency<Auth>().model,
            builder: (context, state, _) {
              final DUser? user = getDependency<Auth>().user;
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text(user.debtsOfType(type).length.toString());
            },
          ),
        );
      },
    );
  }
}
