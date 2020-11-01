import 'dart:ui';
import 'package:eWoke/components/back.dart';
import 'package:eWoke/components/popular_appbar.dart';
import 'package:eWoke/models/episode.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_search/auto_search.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';

import '../ui/full_schedule_card.dart';

class FullSchedule extends StatefulWidget {
  @override
  _FullScheduleState createState() => _FullScheduleState();
}

class _FullScheduleState extends State<FullSchedule> {
  BorderRadius _bottomRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(50.0),
    bottomRight: Radius.circular(50.0),
  );

  final TextEditingController _filter = new TextEditingController();
  String _searchTerm;
  int _currentStep = 0;
  List<List<Episode>> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTerm = "";
    list = scheduledEpisodes;
//    print(sortedList.length);
  }

  Widget _textField() {
    return CupertinoTextField(
      // autofocus: true,
      onSubmitted: (value) {
        setState(() {
          //TODO: SEARCH IN WATCHLIST
          _searchTerm = value;
          list = scheduledEpisodes
              .where((e) => e[0]
              .embedded['show']['name']
              .toLowerCase()
              .contains(_searchTerm.toLowerCase()))
              .toList();
          print(list[0][0].name);
        });
        print("searching");
      },
      // clearButtonMode: OverlayVisibilityMode.editing,
      // keyboardType: TextInputType.text,
      placeholder: "Search",
      placeholderStyle: TextStyle(
        color: greyTextColor.withOpacity(.4),
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      cursorColor: greyTextColor,
      cursorWidth: 3,
      style: TextStyle(
        color: greyTextColor,
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.search,
          color: greyTextColor,
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [ new BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 25.0,
              spreadRadius: -25,
              offset: Offset(0, 5)),
          ],
          color: Colors.white
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    final canCancel = _currentStep > 0;
    final canContinue = _currentStep < list.length-1;
    // print(scheduledEpisodes.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: greenColor,
        child: SafeArea(
          child: Container(
            color: greenColor,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              // key: UniqueKey(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PopularSliverDelegate(
                    // hideTitleWhenExpanded: true,
                    expandedHeight: _height*.13,
                    back: back(context),
                    child: Container(
                      width: _width,
                      decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(sliverRadius),
                            bottomRight: Radius.circular(sliverRadius),
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                            child: _textField(),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverFillRemaining(
                  // fillOverscroll: true,
                  child: scheduledEpisodes.length > 0
                      ? Center(
                          child: Container(
                              height: _height,
                              width: _width,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(sliverRadius),
                                  topRight: Radius.circular(sliverRadius),
                                )
                              ),
                              child: buildCarousel(list),
                        )
                  )
                      : Container(
                          height: _height,
                          child: Text("There are no scheduled shows for you!"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget resultLabel(){
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      child: Center(
        child: list.length < 2
            ? Text(
           "Showing ${list.length} result for \"$_searchTerm\"",
          style: TextStyle(
            color: greenColor,
            fontFamily: 'Raleway',
            fontSize: 20
          ),
        )
            : Text(
      "Showing ${list.length} results for \"$_searchTerm\"",
        style: TextStyle(
            color: greenColor,
            fontFamily: 'Raleway',
            fontSize: 20
        ),
      ),
      ),
    );
  }
  Widget buildCarousel(List<List<Episode>> list) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return CarouselSlider.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        if ( list.length > 0 ){

          return FullScheduleCard(episodes: list[index]);
        }
        else{
          return Container();
        }

      },
      options: CarouselOptions(
        height: _height,
        enableInfiniteScroll: list.length > 1 ? true : false,
        scrollDirection: Axis.vertical,
        viewportFraction: .7,
        aspectRatio: 35 / 9,
        // autoPlay: true
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height
      ),
    );
  }

  List<Step> getStepList(List<List<Episode>> list) {
    List<Step> stepList = [];
    for( List<Episode> x in list){
      stepList.add(new Step(
        content: Container(
          width: 200,
          height: 150,
          child: Text(
              x[0].embedded['show']['name']
          )
        ), title: Text(x[0].name)
      ));
    }
    return stepList;
  }
}
