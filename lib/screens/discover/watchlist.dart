import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/blurry_header.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/components/sort_button.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/ui/filter_bottom_sheet.dart';
import 'package:show_time/ui/sort_bottom_sheet.dart';
import 'package:show_time/ui/watchlist_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';


class DiscoverWatchList extends StatefulWidget {

  @override
  _DiscoverWatchListState createState() => _DiscoverWatchListState();
}

class _DiscoverWatchListState extends State<DiscoverWatchList>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  ShowController showController = Get.find();


  late bool _sorting;
  String criteria = "Criteria";
  bool isPlaying = false;
  late Animation animation;
  late AnimateIconController controller;
  final TextEditingController _filter = new TextEditingController();
  final FloatingSearchBarController _searchBarController = new FloatingSearchBarController();


  @override
  void initState() {
    super.initState();
    _sorting = false;
    controller = AnimateIconController();
    criteria = GlobalVariables.SORT_CATEGORIES[0];
    print("you got like shows: ${showController.watchedShows.length}");
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

    if (kIsWeb){
    return FloatingSearchBar(
      hint: 'Search...',
        controller: _searchBarController,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: 0.0,
        borderRadius: BorderRadius.circular(12),
        openAxisAlignment: 0.0,
        backdropColor: Colors.transparent,
        automaticallyImplyBackButton: false,
        leadingActions: [],
        width: 70,
      openWidth: 250,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          showController.filter(query);
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfClosed: true,
            showIfOpened: false,
            child: CircularButton(
              icon: const FaIcon(
                  FontAwesomeIcons.search,
                color: GlobalColors.greyTextColor,
              ),
              onPressed: () {
                //open search bar
                if ( _searchBarController.isClosed)
                _searchBarController.open();
              },
            ),
          ),
          FloatingSearchBarAction(
            showIfClosed: false,
            showIfOpened: true,
            child: CircularButton(
              icon: const FaIcon(
                FontAwesomeIcons.times,
                color: GlobalColors.greyTextColor,
              ),
              onPressed: () {
                //open search bar
                if ( _searchBarController.isOpen)
                _searchBarController.clear();
                  _searchBarController.close();
              },
            ),
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Colors.accents.map((color) {
                  return Container(height: 112, color: color);
                }).toList(),
              ),
            ),
          );
        },
      );
    }
    else{
      return Container(
        width: Get.width,
        child: CupertinoSearchTextField(
          onChanged: (value) {
            showController.filter(value);
          },
          controller: _filter,
          // keyboardType: TextInputType.text,
          placeholder: "Search watchlist",
          placeholderStyle: TextStyle(
            color: GlobalColors.greyTextColor.withOpacity(.5),
            fontSize: 20.0,
            fontFamily: 'Raleway',
          ),
          itemColor: GlobalColors.greyTextColor,
          style: TextStyle(
            color: GlobalColors.greyTextColor,
            fontSize: 20.0,
            fontFamily: 'Raleway',
          ),
          // prefix: Padding(
          //   padding: const EdgeInsets.only(left: 8.0),
          //   child: Icon(
          //     Icons.search,
          //     color: GlobalColors.greyTextColor,
          //   ),
          // ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [ new BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 25.0,
                  spreadRadius: -25,
                  offset: Offset(0, 5)),
              ],
              color: Colors.white
          ),
        ),
      );
    }

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
        backgroundColor: GlobalColors.watchlistBlue,
        toolbarHeight: 0,
      ),
      body: Container(
        color:  GlobalColors.bgColor,
        child: SafeArea(
          child:  GetBuilder<ShowController>(
            init: showController,
            builder: (_showController) {
              return Stack(
                    children: [
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
                        child: Obx( () => createListView(showController.sortedList.value)),
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
                                color: GlobalColors.watchlistBlue,
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
              );
            }
          ),
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
        backgroundColor: GlobalColors.watchlistBlue,
        expandedHeight: kIsWeb ? _height*.1 : _height*.2,
        back: CustomBackButton(
          backPage: "Home",
          itemColor: GlobalColors.white,
          backgroundColor: GlobalColors.watchlistBlue,
        ),
        actions:  [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
                title: 'Filter',
                icon: FontAwesomeIcons.filter,
                itemColor: GlobalColors.white,
                backgroundColor: GlobalColors.watchlistBlue,
                onTap: () {
                  if ( !kIsWeb) {
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                        ),
                        context: context,
                        builder: (_) {
                          return FilterMenuSheet(
                            onFilter: () {
                              // showController.filter(criteria);
                              // Get.back();
                            },
                          );
                        });
                  }
                  else{
                    Get.dialog(FilterMenuSheet(
                      onFilter: () {
                        // showController.filter(criteria);
                        // Get.back();
                      },
                    )
                        ,transitionDuration: Duration(milliseconds: 300));
                  }

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
              title: 'Sort',
              icon: FontAwesomeIcons.sort,
              itemColor: GlobalColors.white,
              backgroundColor: GlobalColors.watchlistBlue,
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0)),
                      ),
                      context: context,
                      builder: (_) {
                        return SortMenu(
                          onTap: () {
                            setState(() {
                              _sorting = true;
                            });
                            showController.sort(criteria);
                            Get.back();
                          },
                          onSelectItemChanged: (value) {
                            setState(() {
                              criteria = GlobalVariables.SORT_CATEGORIES[value];
                            });
                          },
                        );
                      });
                },
          ),
            ),
        ],
        cancel: _cancelButton(),
        child: _textField(),
      ),
    );
  }

  Widget progressLoading(){
    return Container(
      width: Get.width,
      height: Get.height,
      child: Center(
        child: loadingCouch(),
      ),
    );
  }

  Widget createListView(list) {
      final double _width = Get.size.width;
      final double _height = Get.size.height;
      if ( showController.searchInProgress.value == true){
        return progressLoading();
      }
      if ( list.length > 0){
        return WatchlistView(
          list: list,
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                        color: GlobalColors.watchlistBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(
                          color: GlobalColors.watchlistBlue
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
                    backgroundColor: MaterialStateProperty.all(GlobalColors.bgColor),
                  ),
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


class WatchlistView extends StatelessWidget {
  final List list;

  final ScrollController scrollController = new ScrollController();

  WatchlistView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*.8,
      child: kIsWeb
          ? Scrollbar(
        controller: scrollController,
            child: StaggeredGridView.countBuilder(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        staggeredTileBuilder: (int index) {
          return new StaggeredTile.count(1, index < Get.width~/(Get.width/5) ? .5 : 1);
        },
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        itemCount: list.length +  5, //4 dummy
        itemBuilder: (_, index) {
            if ( index < 5) {
              return SizedBox(
                height: Get.height*.01,
              );
            }
            else{
              return WatchedCardInList(show: list[index-5]);
            }
        },
        crossAxisCount: Get.width~/(Get.width/5),
      ),
          )
         : ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list.length+1,
          itemBuilder: (_, index) {
            if ( index == 0) {
              return SizedBox(
                height: Get.height*.15,
              );
            }
            else{
              return WatchedCardInList(show: list[index-1]);
            }
          }),
    );
  }
}




