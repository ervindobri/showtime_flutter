import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class PopularSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget child;
  final Widget back;
  final Color backgroundColor;
  final Widget? actions;

  PopularSliverDelegate({
    required this.child,
    required this.back,
    this.backgroundColor = GlobalColors.primaryGreen,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    this.actions,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final proportion = 2 - (expandedHeight / appBarSize);

    return Container(
      color: backgroundColor,
      height: expandedHeight,
      child: SizedBox(
          height: appBarSize < minExtent * .6 ? minExtent * .6 : appBarSize,
          child: Column(
            children: [
              Visibility(
                visible: proportion >= 0.0 ? true : false,
                child: Opacity(
                    opacity:
                        proportion >= 0.0 && proportion <= 1.0 ? proportion : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [back, actions ?? const SizedBox()],
                    )),
              ),
              child,
            ],
          )),
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
