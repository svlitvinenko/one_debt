import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/card_theme.dart';
import 'package:one_debt/core/design/theme/color_scheme.dart';
import 'package:one_debt/core/design/theme/dropdown_menu_theme.dart';
import 'package:one_debt/core/design/theme/ds_times.dart';
import 'package:one_debt/core/design/theme/input_decoration_theme.dart';
import 'package:one_debt/core/design/theme/snack_bar_theme.dart';
import 'package:one_debt/core/design/theme/text_selection_theme.dart';
import 'package:one_debt/core/design/theme/text_theme.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

ThemeData getLightTheme(ColorScheme colorScheme) {
  return getThemeData(colorScheme, Brightness.light);
}

ThemeData getDarkTheme(ColorScheme colorScheme) {
  return getThemeData(colorScheme, Brightness.dark);
}

ThemeData getThemeData(ColorScheme colorScheme, Brightness brightness) {
  final TextTheme textTheme = getTextTheme(colorScheme);
  return ThemeData(
    typography: Typography.material2018(platform: defaultTargetPlatform),
    brightness: brightness,
    useMaterial3: false,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: cardTheme(colorScheme),
    dropdownMenuTheme: dropDownMenuTheme(colorScheme),
    textSelectionTheme: getTextSelectionTheme(colorScheme),
    snackBarTheme: snackBarTheme(colorScheme, textTheme),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(width: 0.25),
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: colorScheme.background,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onBackground,
      ),
      toolbarTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onBackground,
      ),
      backgroundColor: colorScheme.background.withOpacity(0.00),
      elevation: 1,
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: colorScheme.onBackground),
    ),
    inputDecorationTheme: inputDecorationTheme(colorScheme),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(colorScheme.onBackground),
        textStyle: MaterialStatePropertyAll(textTheme.titleLarge),
        visualDensity: VisualDensity.comfortable,
      ),
    ),
    extensions: const [
      DSTimes.normal,
    ],
  );
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  DSTimes get times => DSTimes.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get incoming => theme.brightness == Brightness.light
      ? getLightTheme(incomingLightColorScheme)
      : getDarkTheme(incomingDarkColorScheme);
  ThemeData get outgoing => theme.brightness == Brightness.light
      ? getLightTheme(outgoingLightColorScheme)
      : getDarkTheme(outgoingDarkColorScheme);
  ThemeData getThemeByDebtType(EDebtType? type) {
    return switch (type) {
      EDebtType.incoming => incoming,
      EDebtType.outgoing => outgoing,
      null => theme,
    };
  }
}
