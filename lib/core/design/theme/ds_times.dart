import 'dart:ui';

import 'package:flutter/material.dart';

class DSTimes extends ThemeExtension<DSTimes> {
  final Duration fastest;
  final Duration fast;
  final Duration medium;
  final Duration slow;
  final Duration slowest;

  const DSTimes._({
    required this.fastest,
    required this.fast,
    required this.medium,
    required this.slow,
    required this.slowest,
  });

  @override
  ThemeExtension<DSTimes> copyWith({
    Duration? fastest,
    Duration? fast,
    Duration? medium,
    Duration? slow,
    Duration? slowest,
  }) {
    return DSTimes._(
      fastest: fastest ?? this.fastest,
      fast: fast ?? this.fast,
      medium: medium ?? this.medium,
      slow: slow ?? this.slow,
      slowest: slowest ?? this.slowest,
    );
  }

  @override
  ThemeExtension<DSTimes> lerp(covariant ThemeExtension<DSTimes>? other, double t) {
    if (other == null || other is! DSTimes) return this;

    return DSTimes._(
      fastest: Duration(milliseconds: lerpDouble(fastest.inMilliseconds, other.fastest.inMilliseconds, t)!.floor()),
      fast: Duration(milliseconds: lerpDouble(fast.inMilliseconds, other.fast.inMilliseconds, t)!.floor()),
      medium: Duration(milliseconds: lerpDouble(medium.inMilliseconds, other.medium.inMilliseconds, t)!.floor()),
      slow: Duration(milliseconds: lerpDouble(slow.inMilliseconds, other.slow.inMilliseconds, t)!.floor()),
      slowest: Duration(milliseconds: lerpDouble(slowest.inMilliseconds, other.slowest.inMilliseconds, t)!.floor()),
    );
  }

  static const DSTimes normal = DSTimes._(
    fastest: Duration(milliseconds: 150),
    fast: Duration(milliseconds: 250),
    medium: Duration(milliseconds: 350),
    slow: Duration(milliseconds: 700),
    slowest: Duration(milliseconds: 1000),
  );

  static DSTimes of(BuildContext context) => Theme.of(context).extension<DSTimes>()!;
}
