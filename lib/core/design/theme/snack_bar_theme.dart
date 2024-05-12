import 'package:flutter/material.dart';

SnackBarThemeData snackBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
  return SnackBarThemeData(
    elevation: switch (colorScheme.brightness) {
      Brightness.dark => 0,
      Brightness.light => 10,
    },
    contentTextStyle: textTheme.bodyLarge?.copyWith(
      color: colorScheme.onInverseSurface,
    ),
    actionBackgroundColor: colorScheme.onInverseSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorScheme.inverseSurface,
  );
}
