import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/back.dart';
import 'package:eWoke/components/popular_appbar.dart';
import 'package:eWoke/components/search_history_chip.dart';
import 'package:eWoke/components/sliver_appbar.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/ui/search_card.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flare_flutter/flare_actor.dart';


class AllTVShows extends StatefulWidget {
  @override
  _AllTVShowsState createState() => _AllTVShowsState();
}

class _AllTVShowsState extends State<AllTVShows> with TickerProviderStateMixin{
  String _showName = "";
  Future<AllTVShowList> showSearchObject;

  bool _searched;
  int _results = 0;

  var _icon = Icon(Icons.search, color: Colors.white,);
  Icon _searchIcon = Icon(
    Icons.search,
  );
  bool isSearchClicked = false;
  final TextEditingController _filter = new TextEditingController();



  Widget _textField(){
    return CupertinoTextField(
      onSubmitted: (value) {
        if (value != "" ){
          print("searching");
          setState(() {
            _searchShows(value);
          });
        }
        else{
          Fluttertoast.showToast(
              msg: "Search failed!",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: greenColor,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      },
      controller: _filter,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showSearchObject = getSearchResults(showName: _showName);

    setState(() {
      _searched = false;
    });
  }
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,   //new line
      body: Container(
        color: greenColor,
        child: SafeArea(
        child: Container(
          // height: _height*.16,
          color: Colors.white,
          child: _searched
              ? FutureBuilder(
              future: showSearchObject,
              builder: (context, AsyncSnapshot<AllTVShowList> snapshot) {
//            print(snapshot.connectionState);
                if (!snapshot.hasData) {
                  print("nodata");
                  return CustomScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: PopularSliverDelegate(
                            child: Container(
                              width: _width,
                              height: _height*.15,
                              decoration: BoxDecoration(
                                  color: greenColor,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                                    child: _textField(),
                                  ),
                                ],
                              ),
                            ),
                            expandedHeight: _height*.15,
                            hideTitleWhenExpanded: true,
                            back: back(context),

                          ),
                        ),
                        SliverFillRemaining(
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(greenColor),
                              ),
                            ),
                          )
                        )
                      ]
                  );
                }
                else {
                  print(snapshot.data.showList.length);
                  if (snapshot.data.showList.length > 0) {
                    var tags = searchHistory.firstWhere((search) =>
                    search == _showName, orElse: () => null);
                    if (tags == null) {
                      searchHistory.add(_showName);
                      FirestoreUtils().setSearchHistory(_showName);
                    }
                    return Container(
                      color: bgColor,
                      child: CustomScrollView(
                        physics: ClampingScrollPhysics(),
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: PopularSliverDelegate(
                              back: back(context),
                              child: Container(
                                width: _width,
                                decoration: BoxDecoration(
                                    color: greenColor,
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
                                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                                      child: _textField(),
                                    ),
                                  ],
                                ),
                              ),
                              hideTitleWhenExpanded: true,
                              expandedHeight: _height*.15,

                            ),
                          ),
                          SliverList(
                              delegate: SliverChildBuilderDelegate((context, int index) {
//                      children: snapshot.data.showList.map((e) => ShowCard(show: e)).toList(),
                                return ShowCard(show: snapshot.data.showList[index]);
                              }, childCount: snapshot.data.showList.length)
                          )],
                      ),
                    );
                  }
                  else{
                    // SEARCH RESULT NOT FOuND
                    return CustomScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                                    child: _textField(),
                                  ),
                                ],
                              ),
                            ),
                            expandedHeight: _height*.15,
                            hideTitleWhenExpanded: false,
                            back: back(context),

                          ),
                        ),
                        SliverFillRemaining(
                          child: FlareActor(
                              "assets/notfound.flr",
                              color: greenColor.withOpacity(.3),
                              alignment:Alignment.topCenter,
                              fit:BoxFit.fitWidth,
                              animation:"idle"),
                        )
                      ],
                    );
                  }

                }
            }
          )
          : CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: PopularSliverDelegate(
                  child: Container(
                    width: _width,
                    height: _height*.15,
                    decoration: BoxDecoration(
                        color: greenColor,
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
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                            child: _textField(),
                        ),
                      ],
                    ),
                  ),
                  expandedHeight: _height*.15,
                  back: back(context),
                ),
              ),
              SliverFillRemaining(
                // hasScrollBody: false,
                // fillOverscroll: false,
                child: Container(
                  width: _width,
                  height: _height,
                  // color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 25.0),
                       child: displaySearchHistory(context),
                     ),
                      Align(
                        alignment: Alignment.topCenter,
                          child: createSearchResultView(context)),
                    ],
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

  Future<AllTVShowList> getSearchResults({String showName})  =>
       new Network().getShowResults(showName:showName);


  Widget displaySearchHistory(BuildContext context){
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    int _selectedIndex;
    // print(searchHistory);
    return Container(
        width: _width,
//        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Last searches",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: _width/20,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirestoreUtils().getSearchHistory(),
              builder: (context, snapshot) {
                if ( snapshot.hasData){
                  // print(snapshot.data.docs['bad']);
                  return Container(
                    width: _width,
                    height: _height*.3,
                    // color: CupertinoColors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, 2),
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,
                          itemBuilder: (context, int index){
                            return ChoiceChip(
                              selected: _selectedIndex == index,
                              label: Text(
                                snapshot.data.docs[index].data()['term'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: greenColor,
                                    fontFamily: 'Raleway',
                                    fontSize: _width/20
                                ),
                              ),
                              shadowColor: CupertinoColors.black,
                              backgroundColor: Colors.white,
                              elevation: 10,
                              disabledColor: Colors.yellow,
                              onSelected: (bool selected) {
                                //Search if its selected
                                setState(() {
                                  if (selected) {
                                    _selectedIndex = index;
                                    _searchShows(snapshot.data.docs[index].data()['term']);
                                  }
                                });
                              },
                            );
                          }
                      ),
                    ),
                  );
                }
                else{
                  return Container(
                    width: _width,
                    height: _height*.3,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(greenColor),
                      ),
                    ),
                  );
                }

              }
            ),
          ],
        )
    );
  }
  Widget createSearchResultView(BuildContext context){
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    if ( _searched){
      return Expanded(
          child: FutureBuilder(
              future: showSearchObject,
              builder: (context, AsyncSnapshot<AllTVShowList> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(accentColor: greenColor),
                        child:
                        CircularProgressIndicator(strokeWidth: 6.5,
                        ),
                      ),
                    ),
                  );
                }
                else {
                  if (snapshot.data.showList.length > 0) {
                    print("not empty");

                    //If the tag is not added, add to search history
                    var tags = searchHistory.firstWhere((search) =>
                    search == _showName, orElse: () => null);
                    if (tags == null) {
                      searchHistory.add(_showName);
                    }

                    return CustomScrollView(
                      slivers: [SliverList(
                          delegate: SliverChildBuilderDelegate((context, int index) {
//                      children: snapshot.data.showList.map((e) => ShowCard(show: e)).toList(),
                            return ShowCard(show: snapshot.data.showList[index]);
                          }, childCount: snapshot.data.showList.length)
                      )],
                    );
                  }
                  else{
                    print("empty");
                    return CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: FlareActor("assets/notfound.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"idle"),
                        )
                      ],
                    );
                  }
                }
              }),
      );
    }
    else {
      //TODO: change for smooth animation
      return Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                      FontAwesomeIcons.tv,
                  color: greenColor,
                  size: _width/3,),
                  Text(
                    "Search for a show you want to watch",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: greenColor,
                      fontFamily: 'Raleway',
                      fontSize: _height/25,
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }
  }


  _searchShows(String text)  {
    setState(() {
      _showName = text;
      _searched = true;

    });
    showSearchObject = getSearchResults(showName: _showName);
  }


  Widget searchAllTVShowField(BuildContext context) {
    var _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom:10.0),
      child: Container(
        width: MediaQuery.of(context).size.width*.8,
        height: MediaQuery.of(context).size.height*.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: lightGreenColor,

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: _controller,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'Raleway', fontSize: MediaQuery.of(context).size.width/30,),
            onTap: () => _icon = Icon(Icons.clear, color: Colors.white,),
            onChanged: (_) {
              _icon = Icon(Icons.clear, color: Colors.white,);
            },
            onSubmitted: (value) {
              if (value != ""){
                _searchShows(value);
                _icon = Icon(Icons.search, color: Colors.white,);
                FirestoreUtils().setSearchHistory(value);
              }
            },
            decoration: new InputDecoration(
              border: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                      color: greenColor
                  )
              ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: greenColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: greenColor),
                ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greenColor),
              ),
              suffixIcon: InkWell(
                  child: _icon,
              onTap: (){
                    if ( _icon.icon == Icons.clear){
                      print("clear");
                      if ( _controller.text != "") _controller.clear();
                    }
              }),
              hintText: searchHistory.length > 0 ? searchHistory[searchHistory.length-1] : "Search...",
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(.5),
                fontSize: MediaQuery.of(context).size.width/30,
              ),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width/30,
              )
            ),
          ),
        ),
      ),
    );
  }


}

