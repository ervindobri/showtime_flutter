import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/blurry_header.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/ui/watchlist_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';


class DiscoverWatchList extends StatefulWidget {
  final List data;

  const DiscoverWatchList({Key? key, required this.data}) : super(key: key);
  @override
  _DiscoverWatchListState createState() => _DiscoverWatchListState();
}

class _DiscoverWatchListState extends State<DiscoverWatchList>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  ShowController showController = Get.put(ShowController())!;


  late bool _sorting;
  String criteria = "Criteria";
  bool isPlaying = false;
  late Animation animation;
  late AnimateIconController controller;
  final TextEditingController _filter = new TextEditingController();


  @override
  void initState() {
    super.initState();
    _sorting = false;

    controller = AnimateIconController();
    criteria = GlobalVariables.SORT_CATEGORIES[0];
}

  void onListen() {
    setState(() {});
  }


  _onpressed() {
    setState(() {
      if (controller.isStart()) {
        controller.animateToEnd();
      } else if (controller.isEnd()) {
        controller.animateToStart();
      }
    });
  }

  Widget _textField() {
    return CupertinoTextField(
          onChanged: (value) {
            setState(() => showController.filter(value));
          },
          controller: _filter,
          clearButtonMode: OverlayVisibilityMode.editing,
          keyboardType: TextInputType.text,
          placeholder: "Search watchlist",
          placeholderStyle: TextStyle(
            color: GlobalColors.greyTextColor.withOpacity(.5),
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

  Widget build(BuildContext context) {
    //TODO: set scrolloffset to 0 after sorting
    final double _width = Get.width;
    final double _height = Get.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        shadowColor: Colors.transparent,
        backgroundColor: GlobalVariables.watchlistBlue,
        toolbarHeight: 0,
      ),
      body: Container(
        color:  GlobalColors.bgColor,
        child: SafeArea(
          child:  Stack(
                children: [
                  // Container(
                  //   width: _width,
                  //   height: _height*.16,
                  //   decoration: BoxDecoration(
                  //     color: GlobalVariables.watchlistBlue,
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(25.0),
                  //       bottomRight: Radius.circular(25.0),
                  //     )
                  //   ),
                  //   // color: Colors.black,
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                  //           child: _textField(),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  Container(
                    height: _height,
                    decoration: BoxDecoration(
                        color: GlobalColors.bgColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        )
                    ),
                    // ignore: missing_required_param
                    child: createListView(showController.sortedList),
                  ), //pass title, and get content
                  Positioned(
                    bottom: 50,
                    left: 50,
                    child: _sorting
                        ? CustomElevation(
                          color: Colors.blueAccent.withOpacity(.3),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            color: GlobalVariables.watchlistBlue,
                            highlightColor: Colors.blueAccent.shade700,
                            onPressed: () {
                              _onpressed();
                              showController.sort(criteria);
                              print("sorting!");
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: AutoSizeText(
                                      criteria,
                                      minFontSize: 10,
                                      maxFontSize: 20,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  AnimateIcons(
                                    controller: controller,
                                    startIcon: Icons.keyboard_arrow_up,
                                    endIcon: Icons.keyboard_arrow_down,
                                    // add this tooltip for the start icon
                                    startTooltip: 'Icons.add_circle',
                                    // add this tooltip for the end icon
                                    endTooltip: 'Icons.add_circle_outline',
                                    size: 35.0,
                                    duration: Duration(milliseconds: 200),
                                    startIconColor: Colors.white,
                                    endIconColor: Colors.white,
                                    clockwise: false,
                                    onStartIconPress: () {
                                      _onpressed();
                                      showController.sort(criteria);
                                      return true;
                                    },
                                    onEndIconPress: () {
                                      _onpressed();
                                      showController.sort(criteria);
                                      return true;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: _height*.15,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        sliverHeader(),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ),
    );
  }


  sortButton(){
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            context: context,
            builder: (BuildContext context) {
              return createBottomSheet();
            });
      },
      child: Container(
        child: Row(
          children: [
            Text(
              "Sort",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.sort),
              color: Colors.white,
              iconSize: 25,
              onPressed: () async {
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return createBottomSheet();
                    });
              },
            ),
          ],
        ),
      ),
    );
  }


  sliverHeader() {
    final _height = Get.height;
    final _width = Get.width;

    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: BlurrySliverDelegate(
        backgroundColor: GlobalVariables.watchlistBlue,
        expandedHeight: _height*.2,
        back: back(context),
        actions: sortButton(),
        cancel: _cancelButton(),
        child: _textField(),
      ),
    );
  }

  Widget createBottomSheet() {
    double _width = Get.size.width;
    double _height = Get.size.height;
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: _height / 8,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,) // the arrow back icon
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _sorting = true;
                        });
                         showController.sort(criteria);
                         Get.back();
                      },
                      child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: GlobalColors.greyTextColor,
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                          ),
                      ),
                    ),
                  )
                ]),
                Center(
                    child: Text(
                      "Sort",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: GlobalColors.greyTextColor),
                    ) // Your desired title
                ),
              ],
            ),
          ),
          Container(
            height: _height / 2.4,
            color: Colors.white,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 50,
              diameterRatio: 1,
              looping: true,
              useMagnifier: true,
              onSelectedItemChanged: (int value) {
                setState(() {
                  criteria = GlobalVariables.SORT_CATEGORIES[value];
                });
              },
              children: new List<Widget>.generate(GlobalVariables.SORT_CATEGORIES.length, (index){
                return Container(
                  width: _width,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                        GlobalVariables.SORT_CATEGORIES[index],
                        style: TextStyle(
                          color: GlobalColors.greyTextColor,
                          fontSize: 25,
                          fontFamily: 'Raleway',
                        ),
                      )),
                );
              }),

            ),
          )
        ],
      ),
    );
  }

  Widget createListView(List<WatchedTVShow> shows) {
      double _width = MediaQuery.of(context).size.width;
      double _height = MediaQuery.of(context).size.height;
      if ( shows.length > 0){
        return Obx( () =>
          WatchlistView(
            list: showController.sortedList,
            term: showController.searchTerm.value!,
          ),
        );
      }
      else{
        //empty
        return Container(
          width: _width,
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
                  child: AutoSizeText(
                    "Oopsie! You missed that shot. Try again",
                    minFontSize: 20,
                    maxFontSize: 30,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: GlobalVariables.watchlistBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: GlobalVariables.watchlistBlue
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  textColor: GlobalVariables.watchlistBlue,
                  color: GlobalColors.bgColor,
                  onPressed: () {
                      showController.searchTerm.value = "";
                  }, child: Container(
                  width: _width/3.5,
                  child: AutoSizeText(
                    "All shows",
                    minFontSize: 16,
                    maxFontSize: 20,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        decoration: TextDecoration.underline
                    ),
                  ),
                ),
                ),
                SizedBox(
                  width: _width*.8,
                  height: _height/3,
                  child: FlareActor("assets/empty-blue.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Idle"),

                )
              ],
            ),
          ),
        );
      }
    }

  _cancelButton() {
    return InkWell(
      onTap: (){
        setState(() {
          showController.searchTerm.value = "";
          _filter.clear();
        });
      },
      child: Text(
        "Cancel",
        style: GoogleFonts.openSans(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w400
        ),
      ),
    );
  }
}


class WatchlistView extends StatefulWidget {
  final List list;
  final String term;

  const WatchlistView({Key? key, required this.list, required this.term,
    // this.scrollController
  }) : super(key: key);
  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*.8,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: widget.list.length+1,
          itemBuilder: (_, index) {
            if ( index == 0) {
              return SizedBox(
                height: Get.height*.15,
              );
            }
            else{
              return WatchedCardInList(show: widget.list[index-1]);
            }
          }),
    );
  }
}




