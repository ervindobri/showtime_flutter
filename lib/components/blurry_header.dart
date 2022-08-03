import 'package:flutter/material.dart';

class BlurrySliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget? child;
  final Widget back;
  final List<Widget>? actions;
  final Widget? cancel;
  final Color backgroundColor;

  BlurrySliverDelegate({
    required this.backgroundColor,
    this.child,
    required this.back,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    this.actions,
    this.cancel,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // final appBarSize = expandedHeight - (shrinkOffset);
    // final proportion = 2 - (expandedHeight / appBarSize);

    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth > 600) {
          return ClipRRect(
            child: Container(
              height: expandedHeight,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      back,
                      if (actions != null) ...actions!,
                    ],
                  ),
                )),
              ),
            ),
          );
        } else {
          return Container(
              width: constraints.maxWidth,
              height: expandedHeight,
              child: Row(
                children: [
                  back,
                  if (actions != null) ...actions!,
                ],
              ));
        }
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
