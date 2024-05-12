import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/bloc/theme_bloc.dart';
import 'package:one_debt/core/design/theme/color_scheme.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/localization/bloc/localization_bloc.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/routes/app_route.dart';
import 'package:one_debt/routes/routes.dart';
import 'package:one_debt/routes/router.dart';
import 'package:one_debt/routes/title_navigator_observer.dart';

class OneDebtApp extends StatelessWidget {
  const OneDebtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc(getDependency())..add(const ThemeEvent.initialized())),
        BlocProvider(create: (_) => LocalizationBloc(getDependency())..add(const LocalizationEvent.initialized())),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                theme: getLightTheme(defaultLightColorScheme),
                darkTheme: getDarkTheme(defaultDarkColorScheme),
                onGenerateTitle: (context) => AppLocalizations.of(context).title,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeState.locale,
                themeMode: themeState.mode,
                navigatorKey: getDependency<Routes>().navigatorKey,
                initialRoute: const HomeRoute().route,
                onGenerateRoute: generateRoute,
                navigatorObservers: [
                  TitleNavigatorObserver(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
