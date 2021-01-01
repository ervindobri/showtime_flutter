import 'dart:ui';
import 'package:eWoke/components/back.dart';
import 'package:eWoke/components/popular_appbar.dart';
import 'package:eWoke/models/episode.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:eWoke/ui/full_schedule_card.dart';

class FullSchedule extends StatefulWidget {
  @override
  _FullScheduleState createState() => _FullScheduleState();
}

class _FullScheduleState extends State<FullSchedule> {
  // BorderRadius _bottomRadius = const BorderRadius.only(
  //   bottomLeft: Radius.circular(50.0),
  //   bottomRight: Radius.circular(50.0),
  // );

  // final TextEditingController _filter = new TextEditingController();
  String _searchTerm;
  // int _currentStep = 0;
  List<List<Episode>> list = [];

  @override
  void initState() {
    super.initState();
    _searchTerm = "";
    list = GlobalVariables.scheduledEpisodes;
//    print(sortedList.length);
  }

  Widget _textField() {
    return CupertinoTextField(
      // autofocus: true,
      onSubmitted: (value) {
        setState(() {
          //TODO: SEARCH IN WATCHLIST
          _searchTerm = value;
          list = GlobalVariables.scheduledEpisodes
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
        color: GlobalColors.greyTextColor.withOpacity(.4),
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      cursorColor: GlobalColors.greyTextColor,
      cursorWidth: 3,
      style: TextStyle(
        color: GlobalColors.greyTextColor,
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.search,
          color: GlobalColors.greyTextColor,
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
    // const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    // final canCancel = _currentStep > 0;
    // final canContinue = _currentStep < list.length-1;
    // print(scheduledEpisodes.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: GlobalColors.greenColor,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        // leading: null,

      ),
      body: Container(
        color: GlobalColors.greenColor,
        child: SafeArea(
          child: Container(
            color: GlobalColors.greenColor,
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
                    expandedHeight: _height*.15,
                    back: back(context),
                    child: Container(
                      width: _width,
                      decoration: BoxDecoration(
                          color: GlobalColors.greenColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(GlobalVariables.sliverRadius),
                            bottomRight: Radius.circular(GlobalVariables.sliverRadius),
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
                            child: _textField(),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverFillRemaining(
                  // fillOverscroll: true,
                  child: GlobalVariables.scheduledEpisodes.length > 0
                      ? Center(
                          child: Container(
                              height: _height,
                              width: _width,
                              decoration: BoxDecoration(
                                color: GlobalColors.bgColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                  topRight: Radius.circular(GlobalVariables.sliverRadius),
                                )
                              ),
                              child: buildCarousel(list),
                        )
                  )
                      : Container(
                          height: _height,
                          decoration: BoxDecoration(
                              color: GlobalColors.bgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                topRight: Radius.circular(GlobalVariables.sliverRadius),
                              )
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Oh no!",
                                          style: TextStyle(
                                            color: GlobalColors.greyTextColor,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Raleway'
                                          ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "There are no scheduled shows for you!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: GlobalColors.greyTextColor,
                                              fontSize: 27,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Raleway'
                                          ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        width: _width,
                                        height: _height/3,
                                        child: FlareActor("assets/ohno.flr",
                                            alignment: Alignment.center,
                                            fit: BoxFit.contain,
                                            animation: "error-message"),
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
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
            color: GlobalColors.greenColor,
            fontFamily: 'Raleway',
            fontSize: 20
          ),
        )
            : Text(
      "Showing ${list.length} results for \"$_searchTerm\"",
        style: TextStyle(
            color: GlobalColors.greenColor,
            fontFamily: 'Raleway',
            fontSize: 20
        ),
      ),
      ),
    );
  }
  Widget buildCarousel(List<List<Episode>> list) {
    double _height = MediaQuery.of(context).size.height;
    // double _width = MediaQuery.of(context).size.width;

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
