import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/core/model/e_debt_type.dart';
import 'package:one_debt/feature/authentication/authentication_screen.dart';
import 'package:one_debt/feature/contacts/screens/contacts_screen.dart';
import 'package:one_debt/feature/debt/screens/debt_screen.dart';
import 'package:one_debt/feature/debts/screens/debts_screen.dart';
import 'package:one_debt/feature/home/screens/home_screen.dart';
import 'package:one_debt/feature/profile/screens/profile_screen.dart';
import 'package:one_debt/feature/rates/screens/rates_screen.dart';

sealed class AppRouteMatcher {
  const AppRouteMatcher();
  bool matches(RouteSettings settings);
  Widget provide(RouteSettings settings);
  String getTitle(RouteSettings settings, AppLocalizations localizations);

  static const List<AppRouteMatcher> _matchers = [
    AuthenticationRouteMatcher(),
    HomeRouteMatcher(),
    DebtsRouteMatcher(),
    DebtRouteMatcher(),
    ContactsRouteMatcher(),
    ProfileRouteMatcher(),
    RatesRouteMatcher(),
  ];

  static AppRouteMatcher? find(RouteSettings settings) {
    return _matchers.firstWhereOrNull((element) => element.matches(settings));
  }
}

class AuthenticationRouteMatcher extends AppRouteMatcher {
  const AuthenticationRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    return settings.name == '/auth';
  }

  @override
  Widget provide(RouteSettings settings) {
    return const AuthenticationScreen();
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Sign in';
  }
}

class HomeRouteMatcher extends AppRouteMatcher {
  const HomeRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    return settings.name == '/';
  }

  @override
  Widget provide(RouteSettings settings) {
    return const HomeScreen();
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Home';
  }
}

class ContactsRouteMatcher extends AppRouteMatcher {
  const ContactsRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    return settings.name == '/contact';
  }

  @override
  Widget provide(RouteSettings settings) {
    return const ContactsScreen();
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Contacts';
  }
}

class RatesRouteMatcher extends AppRouteMatcher {
  const RatesRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    return settings.name == '/rates';
  }

  @override
  Widget provide(RouteSettings settings) {
    return const RatesScreen();
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Currency rates';
  }
}

class ProfileRouteMatcher extends AppRouteMatcher {
  const ProfileRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    return settings.name == '/profile';
  }

  @override
  Widget provide(RouteSettings settings) {
    return const ProfileScreen();
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Profile';
  }
}

class DebtRouteMatcher extends AppRouteMatcher {
  static final RegExp expression = RegExp(r'^\/(?:incoming|outgoing)\/[A-Za-z\-0-9]+$');

  const DebtRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    final String? name = settings.name;
    if (name == null) return false;
    return expression.hasMatch(name);
  }

  @override
  Widget provide(RouteSettings settings) {
    final String? name = settings.name;
    if (name == null) throw Exception('invalid route');
    final List<String> segments = name.split('/').where((element) => element.isNotEmpty).toList();
    final EDebtType type = switch (segments[0]) {
      'incoming' => EDebtType.incoming,
      'outgoing' => EDebtType.outgoing,
      _ => throw Exception('invalid route'),
    };
    final String id = segments[1];
    return DebtScreen(type: type, id: id);
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Debt';
  }
}

class DebtsRouteMatcher extends AppRouteMatcher {
  static final RegExp expression = RegExp(r'^\/(?:incoming|outgoing)$');

  const DebtsRouteMatcher() : super();
  @override
  bool matches(RouteSettings settings) {
    final String? name = settings.name;
    if (name == null) return false;
    return expression.hasMatch(name);
  }

  @override
  Widget provide(RouteSettings settings) {
    final String? name = settings.name;
    if (name == null) throw Exception('invalid route');
    final List<String> segments = name.split('/').where((element) => element.isNotEmpty).toList();
    final EDebtType type = switch (segments[0]) {
      'incoming' => EDebtType.incoming,
      'outgoing' => EDebtType.outgoing,
      _ => throw Exception('invalid route'),
    };
    return DebtsScreen(type: type);
  }

  @override
  String getTitle(RouteSettings settings, AppLocalizations localizations) {
    return 'Debts';
  }
}
