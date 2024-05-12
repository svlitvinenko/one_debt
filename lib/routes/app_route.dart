import 'package:one_debt/core/model/e_debt_type.dart';

sealed class AppRoute {
  const AppRoute();
  String get route;
}

class HomeRoute extends AppRoute {
  const HomeRoute() : super();

  @override
  String get route => '/';
}

class AuthenticationRoute extends AppRoute {
  const AuthenticationRoute() : super();

  @override
  String get route => '/auth';
}

class ContactsRoute extends AppRoute {
  const ContactsRoute() : super();

  @override
  String get route => '/contact';
}

class RatesRoute extends AppRoute {
  const RatesRoute() : super();

  @override
  String get route => '/rates';
}

class ProfileRoute extends AppRoute {
  const ProfileRoute() : super();

  @override
  String get route => '/profile';
}

class DebtsRoute extends AppRoute {
  final EDebtType type;

  const DebtsRoute({required this.type}) : super();

  @override
  String get route {
    final String debtTypeSegment = switch (type) {
      EDebtType.incoming => 'incoming',
      EDebtType.outgoing => 'outgoing',
    };
    return '/$debtTypeSegment';
  }
}

class DebtRoute extends AppRoute {
  final EDebtType type;
  final String id;

  const DebtRoute({required this.type, required this.id}) : super();

  @override
  String get route {
    final String debtTypeSegment = switch (type) {
      EDebtType.incoming => 'incoming',
      EDebtType.outgoing => 'outgoing',
    };
    return '/$debtTypeSegment/$id';
  }
}
