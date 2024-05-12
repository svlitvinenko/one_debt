import 'package:flutter/widgets.dart';
import 'package:one_debt/core/design/components/ds_bottom_safe_inset.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';

class DebtLoadedContent extends StatelessWidget {
  final DDebtSummary debt;
  final ValueNotifier<bool> isLoadingController;
  const DebtLoadedContent({
    super.key,
    required this.debt,
    required this.isLoadingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  debt.amountInOrigincalCurrency.toString(),
                  style: context.textTheme.displaySmall,
                ),
                if (debt.debt.amount.isoCode != debt.amountInOrigincalCurrency.isoCode) ...[
                  Text(
                    debt.debt.amount.toString(),
                  style: context.textTheme.headlineMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
        Spacer(),
        DSBottomSafeInset(),
      ],
    );
  }
}
