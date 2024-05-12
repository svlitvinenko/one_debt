import 'package:flutter/material.dart';

CardTheme cardTheme(ColorScheme colorScheme) {
  return CardTheme(
    elevation: switch (colorScheme.brightness) {
      Brightness.dark => 0,
      Brightness.light => 8,
    },
    shadowColor: Colors.grey.withOpacity(0.25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    margin: EdgeInsets.zero,
    color: switch (colorScheme.brightness) {
      Brightness.dark => colorScheme.surface,
      Brightness.light => Colors.white,
    },
  );
}
