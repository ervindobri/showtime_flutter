import 'package:auto_size_text/auto_size_text.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_animations/simple_animations.dart';

class WatchedDetailViewPlaceholder extends StatefulWidget {
  const WatchedDetailViewPlaceholder({Key? key}) : super(key: key);

  @override
  _WatchedDetailViewPlaceholderState createState() =>
      _WatchedDetailViewPlaceholderState();
}

class _WatchedDetailViewPlaceholderState
    extends State<WatchedDetailViewPlaceholder> with AnimationMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  List<AnimationController> listControllers = [];
  List<Animation> listAnimations = [];

  var startingColor = GlobalColors.placeholderGrey.withOpacity(.2);
  var endColor = GlobalColors.placeholderGrey;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1690));
    listControllers.add(_animationController);
    listControllers.add(_animationController);
    listControllers.add(_animationController);

    _colorTween = ColorTween(begin: startingColor, end: endColor)
        .animate(_animationController);
    for (var element in listControllers) {
      listAnimations.add(
          ColorTween(begin: startingColor, end: endColor).animate(element));
    }

    // changeColors();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Future changeColors() async {
  //   while (mounted) {
  //     await new Future.delayed(const Duration(milliseconds: 1690), () async {
  //       if (_animationController.status == AnimationStatus.completed) {
  //         _animationController.reverse().orCancel;
  //         listControllers[0].reverse().orCancel;
  //         await new Future.delayed(const Duration(milliseconds: 300), () {
  //           listControllers[1].reverse().orCancel;
  //         });
  //         await new Future.delayed(const Duration(milliseconds: 300), () {
  //           listControllers[2].reverse().orCancel;
  //         });
  //       } else {
  //         // _animationController.forward().orCancel;
  //         listControllers[0].forward().orCancel;
  //         await new Future.delayed(const Duration(milliseconds: 300), () {
  //           listControllers[1].forward().orCancel;
  //         });
  //         await new Future.delayed(const Duration(milliseconds: 300), () {
  //           listControllers[2].forward().orCancel;
  //         });
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      height: _height * .95,
      decoration: const BoxDecoration(
        color: GlobalColors.white,
      ),
      child: SizedBox(
        height: _height * .95,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                SizedBox(
                  height: _height * .55,
                  // color: GlobalColors.placeholderGrey,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        height: _height * .4,
                        decoration: const BoxDecoration(
                          color: GlobalColors.placeholderGrey,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: Container(
                          height: _height / 3.5,
                          width: _width * .4,
                          decoration: const BoxDecoration(
                            color: GlobalColors.placeholderGrey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: _yourProgressPlaceholder(_height, _width),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            displayBadgesPlaceholder(_height, _width),
            displayActions(),
          ],
        ),
      ),
    );
  }

  Widget _yourProgressPlaceholder(double _height, double _width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: AnimatedBuilder(
        builder: (context, child) {
          return Container(
            width: _width * .85,
            height: _height * .25,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: _colorTween.value,
            ),
          );
        },
        animation: _colorTween,
      ),
    );
  }

  Widget displayBadgesPlaceholder(double _height, double _width) {
    // List<Widget> badges = [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor: GlobalColors.placeholderGrey.withOpacity(.2),
                    highlightColor: GlobalColors.placeholderGrey,
                    child: AutoSizeText(
                      "Badges",
                      style: TextStyle(
                        color: GlobalColors.placeholderGrey.withOpacity(.2),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: SizedBox(
              width: _width,
              height: 64,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: FadeShimmer.round(
                      size: 48,
                      baseColor: GlobalColors.placeholderGrey,
                      highlightColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget displayActions() {
    final _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: GlobalColors.placeholderGrey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: GlobalColors.placeholderGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
