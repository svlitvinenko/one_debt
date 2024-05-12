import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/theme.dart';

class DSCard extends StatefulWidget {
  final Widget? title;
  final Widget? child;
  final Widget? background;
  final EdgeInsets? padding;
  final bool isPrimaryContainerColored;
  final bool isTappableChevronEnabled;
  final void Function()? onTap;
  const DSCard({
    super.key,
    this.title,
    this.child,
    this.background,
    this.padding,
    this.isPrimaryContainerColored = false,
    this.onTap,
    this.isTappableChevronEnabled = true,
  });

  @override
  State<DSCard> createState() => _DSCardState();
}

class _DSCardState extends State<DSCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final Widget? title = widget.title;
    final Widget? child = widget.child;
    final Widget? background = widget.background;
    return MouseRegion(
      onHover: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: widget.onTap == null
            ? null
            : isHovered
                ? context.theme.cardTheme.elevation
                : 0,
        color: widget.isPrimaryContainerColored ? context.colorScheme.primaryContainer : null,
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: Colors.transparent,
          child: Stack(
            children: [
              if (background != null) ...[
                Positioned.fill(
                  child: background,
                ),
              ],
              Padding(
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (title != null) ...[
                                  DefaultTextStyle(
                                    style: context.theme.textTheme.titleLarge!.copyWith(
                                      color: widget.isPrimaryContainerColored
                                          ? context.colorScheme.onPrimaryContainer
                                          : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    child: title,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ],
                            ),
                          ),
                          if (widget.onTap != null && widget.isTappableChevronEnabled) ...[
                            const SizedBox(width: 16),
                            Icon(
                              Icons.chevron_right_sharp,
                              size: 24,
                              color: widget.isPrimaryContainerColored ? context.colorScheme.onPrimaryContainer : null,
                            )
                          ]
                        ],
                      ),
                    ),
                    if (child != null) ...[
                      Expanded(child: child),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
