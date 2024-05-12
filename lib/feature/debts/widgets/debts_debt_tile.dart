import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/components/ds_circular_progress_indicator.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/d_debt.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';

class DebtsDebtTile extends StatelessWidget {
  const DebtsDebtTile({
    super.key,
    required this.summary,
    required this.progressDelay,
    required this.onPressed,
  });

  final DDebtSummary summary;
  final Duration progressDelay;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: DSCard(
        isTappableChevronEnabled: false,
        onTap: onPressed,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double progress = summary.debt.progress;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface.withOpacity(0),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: DSCircularProgressIndicator(
                            value: 0.75,
                            startAngle: -3 * pi / 4,
                            colorGenerator: (progress) => context.colorScheme.onBackground.withOpacity(0.15),
                            strokeWidth: 2,
                          ),
                        ),
                        Positioned.fill(
                          child: DSCircularProgressIndicator(
                            value: 0.25 + progress * 1 / 2,
                            startAngle: -3 * pi / 4,
                            colorGenerator: (progress) => Color.lerp(
                              context.colorScheme.primary,
                              context.colorScheme.error,
                              progress / 0.75 - 0.25,
                            ),
                            strokeWidth: 2,
                            delay: progressDelay,
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipOval(
                              child: Builder(
                                builder: (context) {
                                  final String? url = summary.contact.avatarUrl;
                                  if (url != null) {
                                    return Image.network(url);
                                  } else {
                                    return Container(
                                      color: context.colorScheme.primary,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -8,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipOval(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surface,
                                ),
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: Color.lerp(
                                    context.colorScheme.primary,
                                    context.colorScheme.error,
                                    progress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    '${summary.debt.amount}',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.primary,
                      height: 1,
                    ),
                  ),
                  Text(
                    summary.contact.name,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                      height: 1,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Text(
                    '4 days left',
                    style: context.textTheme.bodyLarge,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
