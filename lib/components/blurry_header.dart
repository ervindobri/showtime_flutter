import 'package:flutter/material.dart';

class BlurrySliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget? child;
  final String? title;
  final Widget back;
  final List<Widget>? actions;
  final Widget? cancel;
  final Color backgroundColor;

  BlurrySliverDelegate({
    required this.backgroundColor,
    this.child,
    this.title,
    required this.back,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    this.actions,
    this.cancel,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final width = MediaQuery.of(context).size.width;
    final appBarSize = expandedHeight - (shrinkOffset) + minExtent;
    final progress = shrinkOffset - minExtent / maxExtent;
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth > 600) {
          return ClipRRect(
            child: Container(
              height: expandedHeight,
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      back,
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
              width: width,
              height: appBarSize,
              color: backgroundColor,
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      back,
                      if (actions != null) ...actions!,
                    ],
                  ),
                  if (title != null)
                    AnimatedPositioned(
                      bottom: 10,
                      duration: kThemeAnimationDuration,
                      child: Text(
                        title!,
                        style: TextStyle.lerp(
                            const TextStyle(color: Colors.white, fontSize: 20),
                            const TextStyle(color: Colors.white, fontSize: 16),
                            progress),
                      ),
                    )
                ],
              ));
        }
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 62;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
