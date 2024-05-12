import 'package:flutter/material.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/components/ds_debt_type_theme.dart';
import 'package:one_debt/core/interactor/debts.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/core/model/d_debts.dart';
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
          child: ValueListenableBuilder<DDebts?>(
            valueListenable: getDependency<Debts>().model,
            builder: (context, model, _) {
              if (model == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text(model.ofType(type).length.toString());
            },
          ),
        );
      },
    );
  }
}
