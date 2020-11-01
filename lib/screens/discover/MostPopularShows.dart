import 'package:eWoke/components/back.dart';
import 'package:eWoke/components/popular_appbar.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/network/imdb.dart';
import 'package:eWoke/ui/mps_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class MostPopularShows extends StatefulWidget {




  @override
  _MostPopularShowsState createState() => _MostPopularShowsState();

  MostPopularShows();
}

class _MostPopularShowsState extends State<MostPopularShows> {
  String _searchTerm;
  APIService apiService = APIService();
  List<String> showLinks = [];
  // You future
  Future future;
  Future<dynamic> popular;

  ScrollController _controller;

  double _offset = 1.0;

  String mostPopularLabel = "The 10 most popular shows right now";

  //Querys :          -----------------,         tconst(e.g. tt0944947),
  //Endpoints : title/get-most-popular-tv-shows, title/get-details

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print("mps");
    //in the initState() or use it how you want...
    future = apiService.get(
        endpoint:'/title/get-most-popular-tv-shows',
        query:{"purchaseCountry": "US",
              "currentCountry": "US",
              "homeCountry": "US"
        }
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.removeListener(() {});
    // _controller.dispose();
    // popularShows.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //TODO: set scrolloffset to 0 after sorting ASC/DESC
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));

    // if (_controller.hasClients) print(_controller.position);

    // print(sortedList.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xFFFF006F),
        child: SafeArea(
          child: Container(
            color: const Color(0xFFFF006F),
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                  if ( popularShows.isNotEmpty){
                    print("fetched already");
                    return CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      // key: UniqueKey(),
                      controller: _controller,
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: PopularSliverDelegate(
                            back: back(context),
                            child: Container(
                              width: _width,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFF006F),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25.0),
                                    bottomRight: Radius.circular(25.0),
                                  )
                              ),
                              // color: Colors.black,
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
                            hideTitleWhenExpanded: true,
                            expandedHeight: _height*.15,

                          ),
                        ),
                        SliverFillRemaining(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(sliverRadius),
                                    topRight: Radius.circular(sliverRadius),
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: mostPopularList(popularShows),
                              )),
                        ),
                      ],
                    );
                  }
                  else{
                    if ( snapshot.hasData){
                      // popular.clear();
                      if ( popular == null){
                        getShowLinks(snapshot.data.take(13));
                        popular = getShowList();
                      }
                      // print(popular.length);
                      return FutureBuilder(
                          future: popular,
                          builder: (context, snapshot) {
                            if ( snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                              popularShows = snapshot.data;
                              return CustomScrollView(
                                // key: UniqueKey(),
                                physics: NeverScrollableScrollPhysics(),
                                controller: _controller,
                                slivers: [
                                  SliverPersistentHeader(
                                    delegate: PopularSliverDelegate(
                                      child: Container(
                                        width: _width,
                                        height: _height*.15,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFF006F),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(25.0),
                                              bottomRight: Radius.circular(25.0),
                                            )
                                        ),
                                        // color: Colors.black,
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
                                      expandedHeight: _height*.15,
                                      back: back(context),

                                    ),
                                  ),
                                  // displayLabel(_width),
                                  SliverFillRemaining(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(sliverRadius),
                                              topRight: Radius.circular(sliverRadius),
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: mostPopularList(popularShows),
                                        )),
                                  ),
                                ],
                              );
                            }
                            else{
                              print("fetching data;");
                              return CustomScrollView(
                                // key: UniqueKey(),
                                physics: NeverScrollableScrollPhysics(),
                                controller: _controller,
                                slivers: [
                                  SliverPersistentHeader(
                                    delegate: PopularSliverDelegate(
                                      child: Container(
                                        width: _width,
                                        height: _height*.15,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFF006F),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(25.0),
                                              bottomRight: Radius.circular(25.0),
                                            )
                                        ),
                                        // color: Colors.black,
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
                                      expandedHeight: _height*.15,
                                      back:Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 25.0),
                                              child: InkWell(
                                                onTap: () => Navigator.pop(context),
                                                child: Container(
                                                  // color: CupertinoColors.black
                                                  child: Row(
                                                    children: [
                                                      FaIcon(
                                                        Icons.arrow_back_ios,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Back",
                                                        style: TextStyle(
                                                          decoration: TextDecoration.underline,
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //TODO: refresh button for fetching new data
                                        ],
                                      ),

                                    ),
                                  ),
                                  SliverFillRemaining(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(sliverRadius),
                                              topRight: Radius.circular(sliverRadius),
                                            )
                                        ),
                                        child: Shimmer.fromColors(
                                          highlightColor: Colors.white,
                                          baseColor: Colors.grey.shade300,
                                          direction: ShimmerDirection.ttb,
                                          child: StaggeredGridView.countBuilder(
                                            itemCount: 10,
                                            mainAxisSpacing: 4.0,
                                            crossAxisSpacing: 4.0,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: _height/20,
                                                        width: _width,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade300,
                                                          borderRadius: _radius,
                                                          boxShadow: [ new BoxShadow(
                                                              color: Colors.black.withOpacity(.3),
                                                              blurRadius: 15.0,
                                                              spreadRadius:-4,
                                                              offset: Offset(0, 5)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: _height/3.1,
                                                        width: _width,
                                                        // color: Colors.blue,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade300,
                                                          borderRadius: _radius,
                                                          boxShadow: [ new BoxShadow(
                                                              color: Colors.black.withOpacity(.3),
                                                              blurRadius: 15.0,
                                                              spreadRadius:-4,
                                                              offset: Offset(0, 5)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }, crossAxisCount: 4,
                                            staggeredTileBuilder:(int index) =>
                                            new StaggeredTile.count(2, index.isEven ? 4 : 4),
                                          ),
                                        ),
                                    ),
                                  ),
                                ],
                              );
                            }

                          }
                      );
                    }
                    else{
                      print("Waiting on IMDB data");
                      return CustomScrollView(
                        // key: UniqueKey(),
                        controller: _controller,
                        slivers: [
                          SliverPersistentHeader(
                            delegate: PopularSliverDelegate(
                              child: Container(
                                width: _width,
                                height: _height*.15,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFF006F),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0),
                                    )
                                ),
                                // color: Colors.black,
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
                              expandedHeight: _height*.15,
                              back:Row(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          // color: CupertinoColors.black
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                Icons.arrow_back_ios,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Back",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.white,
                                                  fontFamily: 'Raleway',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //TODO: refresh button for fetching new data
                                ],
                              ),

                            ),
                          ),
                          // displayLabel(_width),
                          SliverFillRemaining(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(sliverRadius),
                                      topRight: Radius.circular(sliverRadius),
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(const Color(0xFFFF006F)),
                                    ),
                                  )
                                )
                            ),
                          ),
                        ],
                      );
                    }
                  }

              }
            ),
          ),
        ),
      ),
    );
  }
  Widget _textField() {
    return CupertinoTextField(
      onSubmitted: (value) {
        setState(() {
          _searchTerm = value;
        });
      },
      // controller: _filter,
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.text,
      placeholder: "Search..",
      placeholderStyle: TextStyle(
        color: greyTextColor,
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

  void getShowLinks(dynamic list) {
    list.forEach((element) {
      showLinks.add(element.split('/')[2]);
    });
    // print(showLinks[0]);
  }
  getShowList() async {
    List<TVShow> data = [];
    for(String show in showLinks.take(13)) {
        TVShow tvshow = await apiService.getShowResults(imdbLink: show);
        // print(tvshow);
        if ( tvshow != null){
          data.add(tvshow);
        }
    }
    return await new Future(() => data);
  }

  Widget mostPopularList(List<dynamic> data) {
    return StaggeredGridView.countBuilder(
      itemCount: data.take(10).length,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PopularCard(show: data[index]),
        );
      }, crossAxisCount: 4,
      staggeredTileBuilder:(int index) =>
    new StaggeredTile.count(2, index.isEven ? 4 : 4),);
  }

  displayLabel(double _width) {
    return Opacity(
      opacity: _offset >= 1 ? 1.0 : _offset <= 0 ? 0.0 : _offset,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Column(
            children: [
              Text(
                mostPopularLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: greyTextColor,
                    fontFamily: 'Raleway',
                    fontSize: _width/15,
                    fontWeight: FontWeight.w700
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 1.2,
                  color: pinkColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
