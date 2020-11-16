import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eWoke/components/back.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:fl_chart/fl_chart.dart';

class OverallProgress extends StatefulWidget {
  @override
  _OverallProgressState createState() => _OverallProgressState();
}

class _OverallProgressState extends State<OverallProgress> with AnimationMixin {
  var grey = Color(DISCOVER_DATA[0][1]);
  Animation<double> sizeAnimation;
  AnimationController animationController;

  TabController _controller;

  int touchedIndex;

  final Duration animDuration = const Duration(milliseconds: 250);

  int length;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.fastOutSlowIn, parent: animationController));
    animationController.forward();

    _controller = TabController(vsync: this, length: 3);
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          brightness: Brightness.dark,
          backgroundColor:  grey,
          shadowColor: Colors.transparent,
        ),
        body: Container(
          height: _height,
          color: grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: grey,
                height: _height*.15,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row
                        (
                        children: [
                          back(context),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        height: _height*.05,
                        width: _width*.8,
                        decoration: BoxDecoration(
                          color: greyTextColor,
                          border: Border.all(
                            color: Colors.white.withOpacity(.2),
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: TabBar(
                          controller: _controller,
                          tabs: [
                            Center(
                              child: Text(
                                "Weekly",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w700,
                                  fontSize: _width/22
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Monthly",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    fontSize: _width/22
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Yearly",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    fontSize: _width/22
                                ),
                              ),
                            ),
                          ],
                          onTap: (index) {
                            // print(index);

                          },
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.white,
                          indicator: RectangularIndicator(
                            bottomLeftRadius: 25,
                            bottomRightRadius: 25,
                            topLeftRadius: 25,
                            topRightRadius: 25,
                            color: Colors.white,
                            paintingStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizeTransition(
              axis: Axis.vertical,
              axisAlignment: 0,
              sizeFactor: sizeAnimation,
                child: Container(
                  height: _height*.81,
                  decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(sliverRadius),
                          topRight: Radius.circular(sliverRadius),
                          )
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: _height*.35,
                        width: _width,
                        child: TabBarView(
                          controller: _controller,
                            children: [
                              Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(18),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [greyTextColor, Colors.grey.shade500]
                                          ),
                                      ),
                                      height: _height/3.5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              "Per Week",
                                              style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FutureBuilder(
                                              future: Statistics().weeklyWatchedEpisodes(),
                                              builder: (context, snapshot) {
                                                if ( snapshot.hasData){
                                                  // print("data");
                                                  List<String> bottomData = [
                                                    Statistics().getWeeksOfYear()[0].toString(),
                                                    Statistics().getWeeksOfYear()[1].toString(),
                                                    Statistics().getWeeksOfYear()[2].toString(),
                                                  ];
                                                  List<double> limits = [0,15,10,0];
                                                  return LineChart(
                                                      sampleData1(limits, bottomData, snapshot.data)
                                                  );
                                                }
                                                else{
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                                    )
                                                  );
                                                }

                                              }
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                              ),
                              Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(18),
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [greyTextColor, Colors.grey.shade500]
                                        ),
                                      ),
                                      height: _height/3.5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              "Month",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FutureBuilder(
                                                future: Statistics().monthlyWatchedEpisodes(),
                                                builder: (context, snapshot) {
                                                  if ( snapshot.hasData){
                                                    // print("data");
                                                    List<String> bottomData = Statistics().getMonths();
                                                    List<double> limits = [0,15,15,0];
                                                    return LineChart(
                                                        sampleData1(limits, bottomData, snapshot.data)
                                                    );
                                                  }
                                                  else{
                                                    return Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                                        )
                                                    );
                                                  }

                                                }
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                              ),
                              Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(18),
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [greyTextColor, Colors.grey.shade500]
                                        ),
                                        boxShadow: [
                                          new BoxShadow(
                                              color: Colors.grey.withOpacity(.3),
                                              blurRadius: 20.0,
                                              spreadRadius: -2,
                                              offset: Offset(0, 3)),
                                        ],
                                      ),
                                      height: _height/3.5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              "Year",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FutureBuilder(
                                                future: Statistics().yearlyWatchedEpisodes(),
                                                builder: (context, snapshot) {
                                                  if ( snapshot.hasData){
                                                    // print("data");
                                                    List<String> bottomData = Statistics().getYears();
                                                    List<double> limits = [0,15,50,0];
                                                    return LineChart(
                                                        sampleData1(limits, bottomData, snapshot.data)
                                                    );
                                                  }
                                                  else{
                                                    return Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                                        )
                                                    );
                                                  }

                                                }
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                              ),
                            ]
                        ),
                      ),
                      Container(
                        height: _height*.45,
                        child: CarouselSlider(
                            items: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: _width*.85,
                                  height: _height/3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [blueColor, Colors.lightBlue]
                                    ),
                                    boxShadow: [
                                      new BoxShadow(
                                          color: blueColor.withOpacity(.3),
                                          blurRadius: 10.0,
                                          spreadRadius: 2,
                                          offset: Offset(0, 3)),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                        child: Text(
                                          "Days of the week",
                                          style: GoogleFonts.roboto(
                                              fontSize: _width/15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),
                                      FutureBuilder(
                                        future: Statistics().getDaysOfShow(),
                                        builder: (context, snapshot) {
                                          if ( snapshot.hasData){
                                            if ( snapshot.data.length > 0 ){
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 40.0,
                                                    bottom: 20.0,
                                                    left: 15,
                                                    right: 15
                                                ),
                                                child: BarChart(
                                                  randomData(snapshot.data),
                                                  swapAnimationDuration: animDuration,
                                                ),
                                              );
                                            }
                                            else{
                                              return Center(
                                                child: Text(
                                                  "Watch some shows first!",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: _width/12,
                                                      color: fireColor,
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              );
                                            }

                                          }
                                          else{
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation(Colors.white),
                                              )
                                            );
                                          }

                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: _width*.8,
                                    height: _height/2.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [Colors.white, Colors.white60]
                                      ),
                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.grey.withOpacity(.3),
                                            blurRadius: 50.0,
                                            spreadRadius: 5,
                                            offset: Offset(0, 3)),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: _width*.4,
                                            lineWidth: 25,
                                            progressColor: fireColor,
                                            backgroundColor: lightFireColor.withOpacity(.3),
                                            circularStrokeCap: CircularStrokeCap.round,
                                            percent: Statistics().getOverallPercent(),
                                            animation: true,
                                            center: Text(
                                              "${(Statistics().getOverallPercent()*100).toInt().toString()} %",
                                              style: GoogleFonts.roboto(
                                                fontSize: _width/12,
                                                color: fireColor,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "O",
                                                style: GoogleFonts.roboto(
                                                  fontSize: _width/10,
                                                  color: fireColor,
                                                  fontWeight: FontWeight.w900
                                                ),
                                              ),
                                              Text(
                                                "V",
                                                style: GoogleFonts.roboto(
                                                    fontSize: _width/10,
                                                    color: fireColor,
                                                    fontWeight: FontWeight.w900
                                                ),
                                              ),
                                              Text(
                                                "R",
                                                style: GoogleFonts.roboto(
                                                    fontSize: _width/10,
                                                    color: fireColor,
                                                    fontWeight: FontWeight.w900
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
                                              //   child: FaIcon(
                                              //     FontAwesomeIcons.spinner,
                                              //     color: greenColor,
                                              //     size: _width/10,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                ),
                              )
                            ],
                            options: CarouselOptions(
                              // height: _height/2.5,
                              aspectRatio: 14/9,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              initialPage: 1
                            ))
                      )
                  ],),
                  ),
              ),
            ],
          ),
        )
    );
  }

  BarChartGroupData makeGroupData(int x, double y, {bool isTouched = false, Color barColor = Colors.white, double width = 20,
        List<int> showTooltips = const [],})
  {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [greenColor] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: (watchedShowList.length/4).toDouble(),
            colors: [Colors.white60],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData randomData(Map<int, int> watchesPerDay) {
    return BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: blueColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toInt().toString(), TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
          const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          margin: 15,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, watchesPerDay[0].toDouble(),isTouched: i == touchedIndex,
                barColor: Colors.white);
          case 1:
            return makeGroupData(1, watchesPerDay[1].toDouble(),isTouched: i == touchedIndex,
                barColor: Colors.white);
          case 2:
            return makeGroupData(2, watchesPerDay[2].toDouble(),isTouched: i == touchedIndex,
                barColor: Colors.white);

        case 3:
            return makeGroupData(3, watchesPerDay[3].toDouble(),isTouched: i == touchedIndex,
            barColor: Colors.white);

        case 4:
            return makeGroupData(4, watchesPerDay[4].toDouble(),isTouched: i == touchedIndex,
            barColor: Colors.white);

          case 5:
            return makeGroupData(5, watchesPerDay[5].toDouble(),isTouched: i == touchedIndex,
        barColor: Colors.white);

          case 6:
            return makeGroupData(6, watchesPerDay[6].toDouble(),isTouched: i == touchedIndex,
        barColor: Colors.white);

          default:
            return null;
        }
      }),
    );
  }

  LineChartData sampleData1(List<double> limits, List<String> bottomData,  List<FlSpot> spotList) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.grey.shade600.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 10,
          getTitles: (value) {
            return getBottomTitles(bottomData, value);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            return getTitlesAccordingToLimits(limits, value);
          },
          reservedSize: 25,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.transparent,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: limits[0],
      maxX: limits[1],
      maxY: limits[2],
      minY: limits[3],
      lineBarsData: linesBarData1(spotList),
    );
  }
  List<LineChartBarData> linesBarData1(List<FlSpot> spotList) {
    // print(spotList[2].y);
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spotList,
      isCurved: true,
      colors: [
        greenColor
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      // lineChartBarData2,
      // lineChartBarData3,
    ];
  }

   getTitlesAccordingToLimits(List<double> limits, double value) {
       if ( value > 0 && value.toInt() % (limits[2]/5) == 0){
         return value.toInt().toString();
       }
    return '';
  }

  getBottomTitles(List<String> bottomData, double value) {
    // print(value);
    if ( bottomData.length > 3){
      switch (value.toInt()) {
        case 0:
          return bottomData[0];
        case 2:
          return bottomData[1];
        case 4:
          return bottomData[2];
        case 7:
          return bottomData[3];
        case 10:
          return bottomData[4];
        case 13:
          return bottomData[5];
      }
    }
    else{
      switch (value.toInt()) {
        case 2:
          return bottomData[0];
        case 7:
          return bottomData[1];
        case 12:
          return bottomData[2];
      }
    }

    return '';
  }
}
