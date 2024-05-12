import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/routes/app_route_matcher.dart';

class TitleNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && previousRoute is PageRoute) {
      _setTitle("push", previousRoute, route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute && oldRoute is PageRoute) {
      _setTitle("replace", oldRoute, newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute && previousRoute is PageRoute) {
      _setTitle("pop", route, previousRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute && previousRoute is PageRoute) {
      _setTitle("pop", route, previousRoute);
    }
  }

  

  void _setTitle(String what, PageRoute<dynamic> routeFrom, PageRoute<dynamic> routeTo) {
    final AppRouteMatcher? matcher = AppRouteMatcher.find(routeTo.settings);
    if (matcher == null) {
      setTitle(title: 'OneDebt', context: null);
      return;
    }
    final NavigatorState? currentState = routes.navigatorKey.currentState;
    final BuildContext? context = currentState?.context;
    if (context == null) {
      setTitle(title: 'OneDebt', context: context);
      return;
    }
    final AppLocalizations localizations = AppLocalizations.of(context);
    setTitle(
      title: '${matcher.getTitle(routeTo.settings, localizations)} — OneDebt',
      context: context,
    );
  }

  void setTitle({required String title, required BuildContext? context}) async {
    Future.microtask(() {
      SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
        label: title,
        primaryColor:
            context?.colorScheme.primary.withOpacity(1.00).value ?? Colors.blue.value, // your app primary color
      ));
    });
  }
}
