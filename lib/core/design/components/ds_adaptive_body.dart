import 'dart:math';

import 'package:flutter/material.dart';

class DSAdaptiveBody extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints, Layout layout) builder;
  const DSAdaptiveBody({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1000 ? 40 : 0),
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return builder.call(context, constraints, constraints.layout);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

extension BoxConstraintsExtension on BoxConstraints {
  Layout get layout {
    final bool isVertical = maxHeight > maxWidth;
    final bool isLarge = min(maxWidth, maxHeight) > 600;
    if (isVertical) {
      if (isLarge) {
        return Layout.verticalLarge;
      } else {
        return Layout.verticalSmall;
      }
    } else {
      if (isLarge) {
        return Layout.horizontalLarge;
      } else {
        return Layout.horizontalSmall;
      }
    }
  }
}

enum Layout {
  verticalSmall,
  verticalLarge,
  horizontalSmall,
  horizontalLarge;

  bool get isVertical => this == Layout.verticalSmall || this == Layout.verticalLarge;
  bool get isHorizontal => this == Layout.horizontalSmall || this == Layout.horizontalLarge;
  bool get isSmall => this == Layout.horizontalSmall || this == Layout.verticalSmall;
  bool get isLarge => this == Layout.horizontalLarge || this == Layout.verticalLarge;
}
