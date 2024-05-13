import 'package:flutter/material.dart';
import 'package:one_debt/core/design/components/ds_adaptive_body.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';

class DSScaffold extends StatelessWidget {
  final DSAppBar? appBar;
  final Widget Function(BuildContext context, BoxConstraints constraints, Layout layout)? body;
  final Widget? background;
  const DSScaffold({
    super.key,
    this.appBar,
    this.body,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final Widget? background = this.background;
    final Widget Function(BuildContext context, BoxConstraints constraints, Layout layout)? body = this.body;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          if (background != null) Positioned.fill(child: background),
          if (body != null)
            Positioned.fill(
              top: 70,
              child: DSAdaptiveBody(
                builder: (context, constraints, layout) => body.call(context, constraints, layout),
              ),
            ),
        ],
      ),
    );
  }
}
