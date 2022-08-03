import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_animations/simple_animations.dart';

class WatchedDetailViewPlaceholder extends StatefulWidget {
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

  var startingColor = Colors.grey;
  var endColor = Colors.grey.shade100;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1690));
    listControllers.add(_animationController);
    listControllers.add(_animationController);
    listControllers.add(_animationController);

    _colorTween = ColorTween(begin: startingColor, end: endColor)
        .animate(_animationController);
    listControllers.forEach((element) {
      listAnimations.add(
          ColorTween(begin: startingColor, end: endColor).animate(element));
    });

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
      decoration: BoxDecoration(
        color: GlobalColors.bgColor,
      ),
      child: Container(
        height: _height * .95,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: _height * .55,
                  // color: GlobalColors.blueColor,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        height: _height * .4,
                        decoration: BoxDecoration(
                          color: GlobalColors.greyTextColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: Container(
                          height: _height / 3.5,
                          width: _width * .4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset:
                                    Offset(10, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          child: _yourProgressPlaceholder(_height, _width)),
                    ],
                  ),
                ),
              ],
            ),
            displayBadgesPlaceholder(_height, _width),
            // FadeIn(.35,_checkIfPopular(_percentage, show.lastWatchDate, show.hasMoreEpisodes())),
            //TODO: when is next episode coming?
            //TODO: related shows
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: displayActions(),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _yourProgressPlaceholder(double _height, double _width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: AnimatedBuilder(
        builder: (context, child) {
          return Container(
            width: _width * .85,
            height: _height * .25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: _colorTween.value,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(2, 5), // changes position of shadow
                ),
              ],
            ),
          );
        },
        animation: _colorTween,
      ),
    );
  }

  Widget displayBadgesPlaceholder(double _height, double _width) {
    List<Widget> badges = [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: Container(
          // color: Colors.grey,
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
                    baseColor: GlobalColors.greyTextColor,
                    highlightColor: Colors.white,
                    child: AutoSizeText(
                      "Badges",
                      style: TextStyle(
                        color: GlobalColors.greyTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: _width / 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(
              width: _width,
              height: _height / 9,
              child: Row(
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: AnimatedBuilder(
                            builder: (context, child) {
                              return Container(
                                width: _height / 9,
                                height: _height / 9,
                                decoration: BoxDecoration(
                                    color: listAnimations[index].value,
                                    shape: BoxShape.circle),
                              );
                            },
                            animation: listAnimations[index],
                          ),
                        )),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget displayActions() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // var timerService = Provider.of<TimerService>(context);

    return Column(
      children: [
        Container(
          // color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: _width / 2.5,
                  height: _width / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: _width / 2.5,
                  height: _width / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
