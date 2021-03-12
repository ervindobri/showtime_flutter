import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/components/popular_appbar.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/ui/search_card.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';


class AllTVShows extends StatefulWidget {
  static const String routeName = "/browse";
  @override
  _AllTVShowsState createState() => _AllTVShowsState();
}

class _AllTVShowsState extends State<AllTVShows> with TickerProviderStateMixin{
  String _showName = "";
  late Future<AllTVShowList> showSearchObject;

  late bool _searched;

  var _icon = Icon(Icons.search, color: Colors.white,);
  bool isSearchClicked = false;
  final TextEditingController _filter = new TextEditingController();
  final bgColor = GlobalColors.blueColor;

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
              backgroundColor: bgColor,
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
        color: GlobalColors.greyTextColor,
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
  void initState() {
    _searched = false;
    super.initState();
    // showSearchObject = getSearchResults(showName: _showName);

    // setState(() {
    //   _searched = false;
    // });
  }
  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: bgColor,
        shadowColor: Colors.transparent,
        brightness: Brightness.dark,
      ),
      body: Container(
        color: bgColor,
        child: SafeArea(
        child: Container(
          // height: _height*.16,
          color: bgColor,
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
                        sliverHeader(_width, _height),
                        SliverFillRemaining(
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
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(bgColor),
                              ),
                            ),
                          )
                        )
                      ]
                  );
                }
                else {
                  print(snapshot.data!.showList.length);
                  if (snapshot.data!.showList.length > 0) {
                    var tags = GlobalVariables.searchHistory.firstWhere((search) =>
                    search == _showName, orElse: () => '');
                    if (tags == '') {
                      GlobalVariables.searchHistory.add(_showName);
                      FirestoreUtils().setSearchHistory(_showName);
                    }
                    return CustomScrollView(
                      physics: ClampingScrollPhysics(),
                      slivers: [
                        sliverHeader(_width, _height),
                        SliverFillRemaining(
                            child: Container(
                              height: _height,
                              width: _width,
                              decoration: BoxDecoration(
                                  color: GlobalColors.bgColor,
                                  // color: CupertinoColors.black,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                    topRight: Radius.circular(GlobalVariables.sliverRadius),
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: ListView.builder(
                                  // physics: PageScrollPhysics(),
                                  itemCount: snapshot.data!.showList.length,
                                  itemBuilder: (context, index){
                                    return ShowCard(show: snapshot.data!.showList[index]);
                                  },
                                ),
                              ),
                            ),

                        )],
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
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
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
                              color: bgColor.withOpacity(.3),
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
              sliverHeader(_width, _height),
              SliverFillRemaining(
                // hasScrollBody: false,
                // fillOverscroll: false,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 25.0),
                       child: displaySearchHistory(context),
                     ),
                      // createSearchResultView(context),
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

  Future<AllTVShowList> getSearchResults({required String showName})  =>
       new Network().getShowResults(showName:showName);

  Widget displaySearchHistory(BuildContext context){
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        width: _width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
              child: Text(
                "Last searches",
                style: TextStyle(
                  color: GlobalColors.greyTextColor,
                  fontSize: _width/20,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirestoreUtils().getSearchHistory(),
              builder: (context, AsyncSnapshot snapshot) {
                if ( snapshot.hasData){
                  // snapshot.data.docs.forEach((element) {
                  //   print(element.data());
                  // });
                  return AnimationLimiter(
                    child: Container(
                      width: _width,
                      height: _height*.4,
                      // color: CupertinoColors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                        child: Wrap(
                          spacing: 3.0, // gap between adjacent chips
                          runSpacing: 2.0, // gap between lines
                          children: List.generate(
                              snapshot.data!.docs.length,
                                  (index) => AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: FadeInAnimation(
                                      delay: Duration(milliseconds: index*25),
                                      child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: CustomElevation(
                                                    color: Colors.grey.withOpacity(.2),
                                                    child: FlatButton(
                                                      color: Colors.white,
                                                      highlightColor: Colors.greenAccent.shade200,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(25.0),),
                                                      ),
                                                      onPressed: (){
                                                        setState(() {
                                                          _searchShows(snapshot.data.docs[index].data()['term']);
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                              snapshot.data.docs[index].data()['term'],
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  decoration: TextDecoration.underline,
                                                                  color: bgColor,
                                                                  fontFamily: 'Raleway',
                                                                  fontSize: _width/20
                                                              ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                    ),
                                  ),
                            ),
                        ),
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
                        valueColor: AlwaysStoppedAnimation(bgColor),
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
                        data: Theme.of(context).copyWith(accentColor: bgColor),
                        child:
                        CircularProgressIndicator(strokeWidth: 6.5,
                        ),
                      ),
                    ),
                  );
                }
                else {
                  if (snapshot.data!.showList.length > 0) {
                    print("not empty");

                    //If the tag is not added, add to search history
                    var tags = GlobalVariables.searchHistory.firstWhere((search) =>
                    search == _showName, orElse: () => '');
                    if (tags == '') {
                      GlobalVariables.searchHistory.add(_showName);
                    }

                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, int index) {
//                      children: snapshot.data.showList.map((e) => ShowCard(show: e)).toList(),
                            return ShowCard(show: snapshot.data!.showList[index]);
                          },
                              childCount: snapshot.data!.showList.length)
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
                  color: bgColor,
                  size: _width/3,),
                  Text(
                    "Search for a show you want to watch",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bgColor,
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
          color: GlobalColors.lightGreenColor,

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
                      color: bgColor
                  )
              ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: bgColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: bgColor),
                ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: bgColor),
              ),
              suffixIcon: InkWell(
                  child: _icon,
              onTap: (){
                    if ( _icon.icon == Icons.clear){
                      print("clear");
                      if ( _controller.text != "") _controller.clear();
                    }
              }),
              hintText: GlobalVariables.searchHistory.length > 0 ? GlobalVariables.searchHistory[GlobalVariables.searchHistory.length-1] : "Search...",
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

  sliverHeader(double _width, double _height) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: PopularSliverDelegate(
        // hideTitleWhenExpanded: true,
        expandedHeight: _height*.15,
        back: back(context),
        // actions: getActions(),
        child: Container(
          width: _width,
          decoration: BoxDecoration(
              color: GlobalColors.blueColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(GlobalVariables.sliverRadius),
                bottomRight: Radius.circular(GlobalVariables.sliverRadius),
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
                child: _textField(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

