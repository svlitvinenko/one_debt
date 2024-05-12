import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/input_decoration_theme.dart';

DropdownMenuThemeData dropDownMenuTheme(ColorScheme colorScheme) {
  return DropdownMenuThemeData(
    inputDecorationTheme: inputDecorationTheme(colorScheme),
    menuStyle: MenuStyle(
      maximumSize: const MaterialStatePropertyAll(Size.fromHeight(200)),
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      elevation: const MaterialStatePropertyAll(10),
      shadowColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.1)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
