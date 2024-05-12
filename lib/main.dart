import 'package:flutter/material.dart';
import 'package:one_debt/app/one_debt_app.dart';
import 'package:one_debt/core/interactor/bootstrap.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/dependencies/initialize_dependencies.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  getDependency<Bootstrap>().initialize();
  runApp(const OneDebtApp());
}
