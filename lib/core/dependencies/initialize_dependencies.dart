import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/interactor/bootstrap.dart';
import 'package:one_debt/core/interactor/contacts.dart';
import 'package:one_debt/core/interactor/currency.dart';
import 'package:one_debt/core/interactor/debts.dart';
import 'package:one_debt/core/interactor/rates.dart';
import 'package:one_debt/core/network/logging_interceptor.dart';
import 'package:one_debt/core/network/rates_network_service.dart';
import 'package:one_debt/firebase_options.dart';
import 'package:one_debt/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final logger = Logger(
    level: Level.trace,
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 80,
      errorMethodCount: 4,
      colors: false,
    ),
  );

  final dio = Dio()
    ..options.connectTimeout = const Duration(seconds: 6)
    ..options.receiveTimeout = const Duration(seconds: 120)
    ..options.followRedirects = true;
  dio.interceptors.add(
    OneDebtLoggingInterceptor(logger),
  );
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final Auth auth = Auth(firebase: FirebaseAuth.instance);
  final Debts debts = Debts();
  final Rates rates = Rates(service: RatesNetworkService(dio: dio));
  final Contacts contacts = Contacts();
  final Currency currency = Currency();
  final Bootstrap bootstrap = Bootstrap(auth: auth, interactors: [auth, rates, contacts, debts, currency]);
  GetIt.I.registerSingleton<Logger>(logger);
  GetIt.I.registerSingleton<Dio>(dio);
  GetIt.I.registerSingleton(preferences);
  GetIt.I.registerSingleton(debts);
  GetIt.I.registerSingleton(bootstrap);
  GetIt.I.registerSingleton(auth);
  GetIt.I.registerSingleton(rates);
  GetIt.I.registerSingleton(contacts);
  GetIt.I.registerSingleton(currency);
  GetIt.I.registerSingleton(Routes());

  await GetIt.I.allReady();
}
