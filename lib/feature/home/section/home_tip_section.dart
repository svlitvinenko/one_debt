import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/feature/home/model/ui/home_tip_model.dart';

class HomeTipSection extends StatefulWidget {
  final List<HomeTipModel> tips;
  const HomeTipSection({super.key, required this.tips});

  @override
  State<HomeTipSection> createState() => _HomeTipSectionState();
}

class _HomeTipSectionState extends State<HomeTipSection> with TickerProviderStateMixin {
  late HomeTipModel currentTip;
  late final AnimationController leftBackgroundController;
  late final AnimationController rightBackgroundController;
  Timer? timer;
  bool isSwitching = false;

  @override
  void initState() {
    currentTip = widget.tips.first;
    leftBackgroundController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rightBackgroundController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    nextTip();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    leftBackgroundController.dispose();
    rightBackgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DSCard(
      background: AnimatedBuilder(
        animation: Listenable.merge([leftBackgroundController, rightBackgroundController]),
        builder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSwitching
                    ? [
                        context.theme.cardColor,
                        context.getThemeByDebtType(currentTip.type.debtType).colorScheme.primary,
                      ]
                    : [
                        context.getThemeByDebtType(currentTip.type.debtType).colorScheme.primary,
                        context.theme.cardColor,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  Curves.easeInOutCubic.transform(leftBackgroundController.value),
                  Curves.easeInOutCubic.transform(rightBackgroundController.value),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: LinearGradient(
                    colors: [
                      context.theme.cardTheme.color!.withOpacity(0.9),
                      context.theme.cardTheme.color!.withOpacity(1.0),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSwitching ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    currentTip.title,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.getThemeByDebtType(currentTip.type.debtType).colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  const Spacer(flex: 1),
                  Text(
                    currentTip.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onBackground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSwitching ? 0 : 1,
            child: IconButton(
              key: ValueKey(currentTip),
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(context.colorScheme.onPrimary),
                iconColor: MaterialStatePropertyAll(context.colorScheme.onPrimary),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.chevron_right_sharp,
                color: context.getThemeByDebtType(currentTip.type.debtType).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> nextTip() async {
    if (!mounted) return;
    setState(() {
      isSwitching = false;
    });
    rightBackgroundController.reset();
    leftBackgroundController.reset();
    rightBackgroundController.animateTo(1, duration: const Duration(seconds: 1));

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await leftBackgroundController.animateTo(1, duration: const Duration(seconds: 1));
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() {
      isSwitching = true;
    });

    rightBackgroundController.reset();
    leftBackgroundController.reset();
    rightBackgroundController.animateTo(1, duration: const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await leftBackgroundController.animateTo(1, duration: const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      currentTip = widget.tips[(widget.tips.indexOf(currentTip) + 1) % widget.tips.length];
    });
    nextTip();
  }
}
