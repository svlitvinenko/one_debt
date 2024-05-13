import 'package:flutter/material.dart';
import 'package:one_debt/core/design/components/ds_adaptive_body.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/d_money.dart';

class RatesAmountFieldDelegate extends SliverPersistentHeaderDelegate {
  ValueNotifier<DMoney> typedCentsController;

  RatesAmountFieldDelegate({required this.typedCentsController});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return RatesAmountField(
      typedCentsController: typedCentsController,
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class RatesAmountField extends StatefulWidget {
  final ValueNotifier<DMoney> typedCentsController;

  const RatesAmountField({
    super.key,
    required this.typedCentsController,
  });

  @override
  State<RatesAmountField> createState() => _RatesAmountFieldState();
}

class _RatesAmountFieldState extends State<RatesAmountField> {
  late final TextEditingController controller;

  @override
  void initState() {
    final int initial = widget.typedCentsController.value.cents;
    final int dollars = initial ~/ 100;
    final int cents = initial % 100;
    controller = TextEditingController(text: '$dollars.$cents');
    controller.addListener(onTextUpdated);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
      ),
      child: Center(
        child: DSAdaptiveBody(
          builder: (context, constraints, layout) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            );
          },
        ),
      ),
    );
  }

  void onTextUpdated() {
    final double? value = double.tryParse(controller.text.replaceAll(',', '.'));
    if (value == null) return;
    final int dollars = value.floor() ~/ 1;
    final int cents = ((value - value.floor()) * 100).floor();
    final int result = dollars * 100 + cents;
    widget.typedCentsController.value = widget.typedCentsController.value.copyWith(cents: result);
  }
}
