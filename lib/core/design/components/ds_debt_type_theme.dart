import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/e_debt_type.dart';

class DSDebtTypeTheme extends StatelessWidget {
  final Widget Function(BuildContext)  builder;
  final EDebtType type;
  const DSDebtTypeTheme({
    super.key,
    required this.builder,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.getThemeByDebtType(type),
      child: Builder(builder: builder),
    );
  }
}
