import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/blurry_header.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/components/sort_button.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/watchlist/presentation/widgets/watchlist_card.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/ui/filter_bottom_sheet.dart';
import 'package:show_time/ui/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';

class DiscoverWatchList extends StatefulWidget {
  @override
  _DiscoverWatchListState createState() => _DiscoverWatchListState();
}

class _DiscoverWatchListState extends State<DiscoverWatchList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();

  late bool _sorting;
  String criteria = "Criteria";
  bool isPlaying = false;
  late Animation animation;
  late AnimateIconController controller;
  final TextEditingController _filter = new TextEditingController();
  final FloatingSearchBarController _searchBarController =
      new FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    _sorting = false;
    controller = AnimateIconController();
    criteria = GlobalVariables.SORT_CATEGORIES[0];
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return FloatingSearchBar(
          hint: 'Search...',
          controller: _searchBarController,
          // scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 400),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          axisAlignment: 0.0,
          borderRadius: BorderRadius.circular(12),
          openAxisAlignment: 0.0,
          backdropColor: Colors.transparent,
          height: 40,
          automaticallyImplyBackButton: false,
          leadingActions: [],
          width: 70,
          openWidth: 250,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            // showController.filter(query);
          },
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfClosed: false,
              showIfOpened: false,
              child: CircularButton(
                icon: const FaIcon(
                  FontAwesomeIcons.search,
                  color: GlobalColors.greyTextColor,
                ),
                onPressed: () {
                  //open search bar
                  if (_searchBarController.isClosed)
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
                  if (_searchBarController.isOpen) _searchBarController.clear();
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
                    return Container(height: 99, color: color);
                  }).toList(),
                ),
              ),
            );
          },
        );
      } else {
        print("mobile");
        return FloatingSearchBar(
          hint: 'Search...',
          controller: _searchBarController,
          // scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 400),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          axisAlignment: 0.0,
          borderRadius: BorderRadius.circular(12),
          openAxisAlignment: 0.0,

          backdropColor: Colors.transparent,
          height: 40,
          automaticallyImplyBackButton: false,
          leadingActions: [],
          padding: EdgeInsets.zero,
          width: 40,
          openWidth: 300,
          onQueryChanged: (query) {
            // showController.filter(query);
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
                  if (_searchBarController.isClosed)
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
                  if (_searchBarController.isOpen) _searchBarController.clear();
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
                    return Container(height: 50, color: color);
                  }).toList(),
                ),
              ),
            );
          },
        );
      }
    });
  }

  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: GlobalColors.watchlistBlue,
        toolbarHeight: 0,
      ),
      body: Container(
        color: GlobalColors.bgColor,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: _height,
                decoration: BoxDecoration(
                    color: GlobalColors.bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    )),
                // ignore: missing_required_param
                child: BlocBuilder<WatchedShowsBloc, WatchedShowsState>(
                  builder: (context, state) {
                    if (state is WatchedShowsLoaded) {
                      final sortedList = state.shows;
                      return createListView(sortedList);
                    } else {
                      return LoadingCouch();
                    }
                  },
                ),
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
                            // showController.sort(criteria);
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
                                    // showController.sort(criteria);
                                    return true;
                                  },
                                  onEndIconPress: () {
                                    _onpressed();
                                    // showController.sort(criteria);
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
                height: 50,
                // color: Colors.black,
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

  sliverHeader() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return SliverPersistentHeader(
      pinned: true,
      delegate: BlurrySliverDelegate(
        backgroundColor: GlobalColors.watchlistBlue,
        expandedHeight: _width > 600 ? 120 : 50,
        back: CustomBackButton(
          backPage: "Home",
          itemColor: GlobalColors.white,
          backgroundColor: GlobalColors.watchlistBlue,
        ),
        actions: [
          // Spacer(),
          Flexible(flex: 2, child: Container(height: 50, child: _textField())),
          CustomButton(
            title: 'Filter',
            icon: FontAwesomeIcons.filter,
            itemColor: GlobalColors.white,
            backgroundColor: GlobalColors.watchlistBlue,
            onTap: () {
              showModalBottomSheet<dynamic>(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                  ),
                  context: context,
                  builder: (_) {
                    return Container(
                      height: MediaQuery.of(context).size.height * .95,
                      child: FilterMenuSheet(
                        onFilter: () {
                          // showController.filter(criteria);
                          // Get.back();
                          NavUtils.back(context);
                        },
                      ),
                    );
                  });
            },
          ),
          SizedBox(width: 16),

          if (MediaQuery.of(context).size.width > 600)
            CustomButton(
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
                          // showController.sort(criteria);
                          NavUtils.back(context);
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
        ],
        cancel: _cancelButton(),
      ),
    );
  }

  Widget progressLoading() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: LoadingCouch(),
      ),
    );
  }

  Widget createListView(list) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    if (list.length > 0) {
      return WatchlistView(
        list: list,
      );
    } else {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
                child: AutoSizeText(
                  "Oopsie! You missed that shot. Try again",
                  minFontSize: 20,
                  maxFontSize: 30,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: GlobalColors.watchlistBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: GlobalColors.watchlistBlue),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all(GlobalColors.bgColor),
                ),
                onPressed: () {
                  // showController.searchTerm.value = "";
                },
                child: Container(
                  width: _width / 3.5,
                  child: AutoSizeText(
                    "All shows",
                    minFontSize: 16,
                    maxFontSize: 20,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 25, decoration: TextDecoration.underline),
                  ),
                ),
              ),
              SizedBox(
                width: _width * .8,
                height: _height / 3,
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
      onTap: () {
        setState(() {
          // showController.searchTerm.value = "";
          _filter.clear();
        });
      },
      child: Text(
        "Cancel",
        style: GoogleFonts.openSans(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class WatchlistView extends StatefulWidget {
  final List list;

  WatchlistView({Key? key, required this.list}) : super(key: key);

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        int items = (constraints.maxWidth / (270)).floor();
        return Scrollbar(
          controller: scrollController,
          child: StaggeredGridView.countBuilder(
            controller: scrollController,
            staggeredTileBuilder: (int index) {
              return new StaggeredTile.count(1, index < items ? .5 : 1.5);
            },
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            itemCount: widget.list.length + items, //4 dummy
            itemBuilder: (_, index) {
              if (index < items) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .005,
                );
              } else {
                return WatchedCardInList(show: widget.list[index - items]);
              }
            },
            crossAxisCount: items,
          ),
        );
      } else {
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.list.length + 1,
            itemBuilder: (_, index) {
              if (index == 0) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .15,
                );
              } else {
                return WatchedCardInList(show: widget.list[index - 1]);
              }
            });
      }
    });
  }
}
