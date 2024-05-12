import 'package:flutter/widgets.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return DSScaffold(
      appBar: DSAppBar(
        title: Text(localizations.contactsTitle),
      ),
    );
  }
}
