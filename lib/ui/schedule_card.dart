import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ScheduleCard extends StatefulWidget {
  final Episode episode;


  ScheduleCard({this.episode});

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  String _countdownLabel = "";
  Timer _timer;
  int _start = 0;
  PaletteGenerator paletteGenerator;

  Rect region;

  Color color = Colors.white;

  Color episodeLabelColor = greyTextColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Initialize the label text
    _countdownLabel = widget.episode.getDifference();
    startCountdown();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
  @override
  void didUpdateWidget(ScheduleCard oldWidget){
    super.didUpdateWidget(oldWidget);
    print("updated");
  }

  getDominantColor() async {
    color = await getImagePalette(NetworkImage(widget.episode.embedded['show']['image']['medium']));
  }

  // Calculate dominant color from ImageProvider
  Future<Color> getImagePalette (ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  }

  void startCountdown() {
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _countdownLabel = widget.episode.getDifference();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const BorderRadius _leftRadius = BorderRadius.only(
        topLeft:  Radius.circular(75.0),
        bottomRight: Radius.circular(25.0),
        bottomLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
    );
    double airHeight = _height/13;
    double cardHeight = _height / 4.2;
    double cardWidth = _height / 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: GestureDetector(
        onTap: () => print("scheduled show"),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _leftRadius,
            boxShadow: [ new BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 15.0,
                spreadRadius:-5,
                offset: Offset(0, 5)),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: 30,
                child: Container(
                  // color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        Container(
                          // color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                               Container(
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.only(
                                       topLeft: Radius.circular(75.0),
                                       topRight: Radius.circular(25.0),
                                     ),
                                     color: greyTextColor
                                 ),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     Container(
                                          // color: Colors.black,
                                          width: cardWidth,
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 50.0, right: 10, top: 10),
                                            child: AutoSizeText(
                                                widget.episode.embedded['show']['name'],
                                                textAlign: TextAlign.right,
                                                softWrap: true,
                                                maxFontSize: 25,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: _width / 15,
                                                  fontWeight: FontWeight.w700,
                                                  // fontFamily: 'Raleway',
                                                )
                                            ),
                                          ),
                                      ),
                                     Padding(
                                       padding: const EdgeInsets.only(bottom: 10.0, right: 20),
                                       child: AutoSizeText(
                                           widget.episode.name,
                                           textAlign: TextAlign.right,
                                           style: GoogleFonts.roboto(
                                             color: Colors.white,
                                             fontStyle: FontStyle.italic,
                                             fontSize: _width / 23,
                                             // fontWeight: FontWeight.w700,
                                             // fontFamily: 'Raleway',
                                           )
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                          height: cardHeight/3,
                                          width: cardWidth*.8,
                                          // color: Colors.black12,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    AutoSizeText(
                                                      widget.episode.season.toString(),
                                                      minFontSize: 10,
                                                      maxFontSize: 25,
                                                      style: TextStyle(
                                                          shadows: <Shadow>
                                                          [Shadow(
                                                              offset: Offset(0.0, 3.0),
                                                              blurRadius: 15.0,
                                                              color: Colors.black
                                                                .withOpacity(.2),
                                                            ),
                                                          ],
                                                          fontWeight: FontWeight.w700,
//                                                color: greyTextColor,
//                                                color: Colors.white,
                                                          color: episodeLabelColor,

                                                          fontSize: _width / 10,
                                                          fontFamily: 'Raleway'
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      "Season",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w300,
//                                                color: Colors.white,
                                                          color: episodeLabelColor,
                                                          fontSize: _width / 25,
                                                          fontFamily: 'Raleway'
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    AutoSizeText(
                                                      widget.episode.episode.toString(),
                                                      minFontSize: 15,
                                                      maxFontSize: 25,
                                                      style: TextStyle(
                                                          shadows: [Shadow(
                                                            offset: Offset(0.0, 3.0),
                                                            blurRadius: 15.0,
                                                            color: Colors.black
                                                                .withOpacity(.2),
                                                          ),
                                                          ],
                                                          fontWeight: FontWeight.w700,
//                                                color: greyTextColor,
                                                          color: episodeLabelColor,
//                                                color: Colors.white,
//                                                fontSize: _width / 10,
                                                          fontSize: _width / 10,

                                                          fontFamily: 'Raleway'
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      "Episode",
                                                      textAlign: TextAlign.left,
                                                      minFontSize: 13,
                                                      maxFontSize: 15,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          color: episodeLabelColor,
//                                                color: Colors.white,
                                                          fontSize: _width / 25,
                                                          fontFamily: 'Raleway'
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -(airHeight / 2),
                child: Container(
                  height: airHeight+5,
                  width: _width * .35,
                  decoration: BoxDecoration(
                      color:  widget.episode.getDiffDays().abs() > 3 ? lightGreenColor : orangeColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      boxShadow: [new BoxShadow(
                          color:widget.episode.getDiffDays().abs() > 3 ? lightGreenColor.withOpacity(.5) : fireColor.withOpacity(1),
                          blurRadius: 5.0,
                          spreadRadius: -2,
                          offset: Offset(0, 2)
                      )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          widget.episode.getAirDateLabel(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: _width / 25,
                            fontFamily: 'Raleway',
                          )
                      ),
                      Container(
                        height: (airHeight+10)/2,
                        width: _width * .35,
                        child: Center(
                          child: AutoSizeText(
                              widget.episode.getDiffDays() >= 0 ? "Available": widget.episode.airTime,
                              // textAlign: TextAlign.center,
                              minFontSize: 25,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                // fontSize: _width / 15,
                                fontFamily: 'Raleway',
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.episode.getDiffDays() >= 0
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [ blueColor, lightGreenColor]
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0),
                                bottomLeft: Radius.circular(25.0),
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.eye,
                                color: Colors.white,
                                size: 35,
                              ),
                            )
                        ))
                    : Positioned(
                        top: -50,
                        left: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 110,
                            height: 30,
                            // color: Colors.black,
                            child: Center(
                              child: Text(
                                _countdownLabel,
                                style: GoogleFonts.roboto(
                                  color: greyTextColor.withOpacity(.4),
                                  fontSize: _width/20,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                          ),
                        ),),
            ],
          ),
        ),
      ),
    );
  }





}
