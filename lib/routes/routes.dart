import 'package:flutter/widgets.dart';
import 'package:one_debt/routes/app_route.dart';

class Routes {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future<T?> push<T>(AppRoute route) async {
    final NavigatorState? currentState = navigatorKey.currentState;
    if (currentState == null) {
      return null;
    }
    return currentState.pushNamed(route.route);
  }

  Future<T?> replaceAll<T>(AppRoute route) async {
    final NavigatorState? currentState = navigatorKey.currentState;
    if (currentState == null) {
      return null;
    }
    return currentState.pushNamedAndRemoveUntil(route.route, (_) => false);
  }

  void pop<T>({T? result}) {
    return navigatorKey.currentState?.pop(result);
  }
}
