import 'package:flutter/material.dart';
import 'package:one_debt/feature/not_found/screens/not_found_screen.dart';
import 'package:one_debt/routes/app_route_matcher.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final AppRouteMatcher? matcher = AppRouteMatcher.find(settings);
  if (matcher == null) {
    return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  }

  return MaterialPageRoute(
      builder: (context) {
        return matcher.provide(settings);
      },
      settings: settings);
}
