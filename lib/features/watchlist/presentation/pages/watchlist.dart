import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/blurry_header.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/watchlist/presentation/widgets/watchlist_card.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';

class DiscoverWatchList extends StatefulWidget {
  const DiscoverWatchList({Key? key}) : super(key: key);

  @override
  _DiscoverWatchListState createState() => _DiscoverWatchListState();
}

class _DiscoverWatchListState extends State<DiscoverWatchList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late bool _sorting;
  String criteria = "Criteria";
  bool isPlaying = false;
  late Animation animation;
  late AnimateIconController controller;

  @override
  void initState() {
    super.initState();
    _sorting = false;
    controller = AnimateIconController();
    criteria = GlobalVariables.sortCategories[0];
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

  @override
  Widget build(BuildContext context) {
    // final double _width = MediaQuery.of(context).size.width;
    // final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalColors.bgColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: GlobalColors.watchlistBlue,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              sliverHeader(),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
              BlocBuilder<WatchedShowsBloc, WatchedShowsState>(
                builder: (context, state) {
                  if (state is WatchedShowsLoaded) {
                    final sortedList = state.shows as List<WatchedTVShow>;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Column(
                            children: [
                              WatchedCardInList(show: sortedList[index]),
                              Divider(
                                color:
                                    GlobalColors.greyTextColor.withOpacity(.2),
                              ),
                            ],
                          );
                        },
                        childCount: sortedList.length,
                      ),
                    );
                  } else {
                    return const SliverFillRemaining(child: LoadingCouch());
                  }
                },
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 50,
            child: _sorting
                ? CustomElevation(
                    color: Colors.blueAccent.withOpacity(.3),
                    child: TextButton(
                      onPressed: () {
                        _onpressed();
                        // showController.sort(criteria);
                        // print("sorting!");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              criteria,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontSize: 16,
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
                            duration: const Duration(milliseconds: 200),
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
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(),
                  ),
          ),
        ],
      ),
    );
  }

  sliverHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: BlurrySliverDelegate(
          backgroundColor: GlobalColors.watchlistBlue,
          expandedHeight: 100,
          back: const CustomBackButton(
            backPage: "Home",
            itemColor: GlobalColors.white,
          ),
          title: 'Watchlist',
          actions: [
            const FaIcon(FontAwesomeIcons.search, color: Colors.white),
          ]
          // actions: [
          //   // Spacer(),
          //   Flexible(flex: 2, child: SizedBox(height: 50, child: _textField())),
          //   CustomButton(
          //     title: 'Filter',
          //     icon: FontAwesomeIcons.filter,
          //     itemColor: GlobalColors.white,
          //     backgroundColor: GlobalColors.watchlistBlue,
          //     onTap: () {
          //       showModalBottomSheet<dynamic>(
          //           backgroundColor: Colors.white,
          //           isScrollControlled: true,
          //           shape: const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(25.0),
          //                 topRight: Radius.circular(25.0)),
          //           ),
          //           context: context,
          //           builder: (_) {
          //             return SizedBox(
          //               height: MediaQuery.of(context).size.height * .95,
          //               child: FilterMenuSheet(
          //                 onFilter: () {
          //                   // showController.filter(criteria);
          //                   // Get.back();
          //                   NavUtils.back(context);
          //                 },
          //               ),
          //             );
          //           });
          //     },
          //   ),
          //   const SizedBox(width: 16),

          //   if (MediaQuery.of(context).size.width > 600)
          //     CustomButton(
          //       title: 'Sort',
          //       icon: FontAwesomeIcons.sort,
          //       itemColor: GlobalColors.white,
          //       backgroundColor: GlobalColors.watchlistBlue,
          //       onTap: () {
          //         showModalBottomSheet(
          //             backgroundColor: Colors.white,
          //             shape: const RoundedRectangleBorder(
          //               borderRadius: BorderRadius.only(
          //                   topLeft: Radius.circular(25.0),
          //                   topRight: Radius.circular(25.0)),
          //             ),
          //             context: context,
          //             builder: (_) {
          //               return SortMenu(
          //                 onTap: () {
          //                   setState(() {
          //                     _sorting = true;
          //                   });
          //                   // showController.sort(criteria);
          //                   NavUtils.back(context);
          //                 },
          //                 onSelectItemChanged: (value) {
          //                   setState(() {
          //                     criteria = GlobalVariables.SORT_CATEGORIES[value];
          //                   });
          //                 },
          //               );
          //             });
          //       },
          //     ),
          // ],
          // cancel: _cancelButton(),
          ),
    );
  }

  Widget progressLoading() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const Center(
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
      return SizedBox(
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
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    side: BorderSide(color: GlobalColors.watchlistBlue),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all(GlobalColors.bgColor),
                ),
                onPressed: () {
                  // showController.searchTerm.value = "";
                },
                child: SizedBox(
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
                child: const FlareActor("assets/empty-blue.flr",
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
}

class WatchlistView extends StatefulWidget {
  final List list;

  const WatchlistView({Key? key, required this.list}) : super(key: key);

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final ScrollController scrollController = ScrollController();

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
              return StaggeredTile.count(1, index < items ? .5 : 1.5);
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
        return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.list.length,
            padding: const EdgeInsets.fromLTRB(0, 64, 0, 0),
            separatorBuilder: (_, index) {
              return Divider(
                color: GlobalColors.greyTextColor.withOpacity(.2),
              );
            },
            itemBuilder: (_, index) {
              return WatchedCardInList(show: widget.list[index]);
            });
      }
    });
  }
}
