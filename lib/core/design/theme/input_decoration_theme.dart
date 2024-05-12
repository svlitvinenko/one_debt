import 'package:flutter/material.dart';

InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
  final OutlineInputBorder defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: colorScheme.outline,
    ),
  );
  final OutlineInputBorder errorBorder = defaultBorder.copyWith(
    borderSide: BorderSide(color: colorScheme.error),
  );
  return InputDecorationTheme(
    isDense: true,
    border: defaultBorder,
    enabledBorder: defaultBorder,
    focusedBorder: defaultBorder,
    disabledBorder: defaultBorder,
    errorBorder: errorBorder,
    focusedErrorBorder: errorBorder,
  );
}
