import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/theme.dart';

class DSCircularProgressIndicator extends StatefulWidget {
  final double? value;
  final Color? Function(double value)? colorGenerator;
  final Duration? delay;
  final double? startAngle;
  final double strokeWidth;
  const DSCircularProgressIndicator({
    super.key,
    this.value,
    this.colorGenerator,
    this.delay,
    this.startAngle,
    this.strokeWidth = 4.0,
  });

  @override
  State<DSCircularProgressIndicator> createState() => _DSCircularProgressIndicatorState();
}

class _DSCircularProgressIndicatorState extends State<DSCircularProgressIndicator> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final double? value = widget.value;
    if (value == null) {
      controller.value = 1;
    } else {
      _launchAfterDelay();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double? value = widget.value;
    final Color? Function(double) colorGenerator = widget.colorGenerator ?? (_) => context.colorScheme.primary;
    return Transform.rotate(
      angle: widget.startAngle ?? 0,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final double? progress = value != null ? Curves.easeInOutCubic.transform(controller.value) * value : null;
          return CircularProgressIndicator(
            color: colorGenerator.call(progress ?? 1.0),
            value: progress,
            strokeWidth: widget.strokeWidth,
          );
        },
      ),
    );
  }

  Future<void> _launchAfterDelay() async {
    if (!context.mounted) return;
    await Future.delayed(widget.delay ?? Duration.zero);
    if (!context.mounted) return;
    controller.forward();
  }
}
