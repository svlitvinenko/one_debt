import 'package:flutter/material.dart';

TextSelectionThemeData getTextSelectionTheme(ColorScheme colorScheme) {
  return TextSelectionThemeData(
    cursorColor: colorScheme.primary,
    selectionColor: colorScheme.primaryContainer,
    selectionHandleColor: colorScheme.primary,
  );
}
