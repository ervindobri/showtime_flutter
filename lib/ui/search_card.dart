
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/screens/detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:status_alert/status_alert.dart';
import 'package:html/parser.dart';

class ShowCard extends StatefulWidget {

  final TVShow show;

  final BorderRadiusGeometry _leftRadius = const BorderRadius.only(
    bottomRight: Radius.circular(25.0),
    topRight: Radius.circular(50.0),
  );


  const ShowCard({Key key, this.show}) : super(key: key);

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {

  TVShowDetails showDetails;

  bool _added = false;

  bool _done = false;

  double radius = 25.0;

  getDetailResults({TVShow show}) => new Network().getDetailResults(show: show);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _done = false;
    });
    super.initState();
    _checkIfAdded();
    _getShowDetails();

  }

  _checkIfAdded()async{
    var res = await FirestoreUtils().checkIfShowExists(widget.show.id);
    setState(()  {
      _added = res;
    });
  }
 _getShowDetails() async {
//    print("getting details: ${widget.show.name}");
    showDetails =  await getDetailResults(show: widget.show);
 }

 @override
  void didUpdateWidget(ShowCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
//    print("updated");
    _getShowDetails();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const BorderRadius _bottomRadius = BorderRadius.only(
      bottomLeft:Radius.circular(25.0),
      bottomRight:Radius.circular(25.0),
    );

    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 25),
        child: InkWell(
          onTap: (){
            //TODO: add snapping sheet
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius)
                    ),
                    child: NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        print("${notification.extent}");
                        if ( notification.extent == 1.0){
                          setState(() {
                            radius = 0.0;
                          });
                        }
                        return true;

                      },
                      child: DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: .62,
                          minChildSize: 0.3,
                          maxChildSize: .95, //TODO: calculate safe height
                          builder: (context, scrollController) => DetailView(tvshow: widget.show, show: showDetails, controller: scrollController)
                      ),
                    ),
                  );
                },
                isScrollControlled: true);

          },
          child: Hero(
              tag: 'thumbnailPhoto${widget.show.id}',
              child: Container(
                  width: _width*.3,
                  height: _height/1.7,
                  constraints: BoxConstraints(
                      maxWidth: _width * 0.7,
                      maxHeight: _height/1.7
                    ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    image: DecorationImage(
                          image: NetworkImage(widget.show.imageThumbnailPath),
                          fit: BoxFit.fill),
                    borderRadius: _radius,
                    boxShadow: [ new BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        blurRadius: 5.0,
                        spreadRadius:-2,
                        offset: Offset(2, 5)),
                    ],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                          Stack(
                              children: [
                                  new ClipRRect(
                                      borderRadius: _bottomRadius,
                                      child: new BackdropFilter(
                                        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                        child: new Container(
                                          width: _width,
                                          height: _height/6,
                                          decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                            borderRadius: _bottomRadius,
                                          ),
                                          child: new Center(
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 18.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: _width / 3,
                                                                height: _height / 25,
                                                                decoration: BoxDecoration(
                                                                  color: greyTextColor,
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(25.0),
                                                                    topRight: Radius.circular(25.0),
                                                                    bottomLeft: Radius.circular(25.0),
                                                                    bottomRight: Radius.circular(25.0),),
                                                                  boxShadow: [
                                                                    new BoxShadow(
                                                                        color: Colors.black.withOpacity(.1),
                                                                        blurRadius: 15.0,
                                                                        spreadRadius: 3,
                                                                        offset: Offset(0, 0)),],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Text(
                                                                      "Runtime",
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontFamily: 'Raleway',
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: MediaQuery.of(context).size.width / 25,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${widget.show.runtime}",
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontFamily: 'Raleway',
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: MediaQuery.of(context).size.width / 25,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width / 3,
                                                                height: MediaQuery.of(context).size.height / 25,
                                                                decoration: BoxDecoration(
                                                                  color: fireColor,
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(25.0),
                                                                    topRight: Radius.circular(25.0),
                                                                    bottomLeft: Radius.circular(25.0),
                                                                    bottomRight: Radius.circular(25.0),),
                                                                  boxShadow: [
                                                                    new BoxShadow(
                                                                        color: Colors.black.withOpacity(.1),
                                                                        blurRadius: 15.0,
                                                                        spreadRadius: 3,
                                                                        offset: Offset(0, 0)),],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Center(
                                                                      child: Text(
                                                                        "Rating",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontFamily: 'Raleway',
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: MediaQuery.of(context).size.width / 25,

                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        "${widget.show.rating == 0 ? r"N\A" : widget.show.rating}",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontFamily: 'Raleway',
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: MediaQuery.of(context).size.width / 25,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                              ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(12.0),
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.height/ 9,
                                                            height: MediaQuery.of(context).size.height / 10,
                                                            decoration: BoxDecoration(
                                                              color: blueColor,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(25)),
                                                              boxShadow: [ new BoxShadow(
                                                                  color: blueColor.withOpacity(.1),
                                                                  blurRadius: 12.0,
                                                                  spreadRadius: 2,
                                                                  offset: Offset.fromDirection(5, 0)),
                                                              ],),
                                                            child: Container(
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  if (!_added) {
                                                                    FirestoreUtils().addToWatchedShows(showDetails);
                                                                    setState(() {_added = true; });
                                                                    StatusAlert.show(
                                                                      context,
                                                                      duration: Duration(seconds: 2),
                                                                      blurPower: 5.0,
                                                                      title: 'Show added',
                                                                      configuration: IconConfiguration(
                                                                          icon: Icons.done),
                                                                    );
                                                                  }
                                                                  else {
                                                                    // print(widget.show.id);
                                                                    //FOR UPDATING SHOWS RATING
                                                                    // _updateRating(showDetails);
                                                                    StatusAlert.show(
                                                                      context,
                                                                      duration: Duration(seconds: 2),
                                                                      blurPower: 5.0,
                                                                      title: " ${widget.show.name} already added!",
                                                                      configuration: IconConfiguration(
                                                                          icon: Icons.info),
                                                                    );
                                                                  }
                                                                },
                                                                icon: FaIcon(
                                                                  FontAwesomeIcons.couch,
                                                                  color: Colors.white,
                                                                  size: MediaQuery.of(context).size.width / 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ],
                            ),

                        ],
                    ) ,
              )
          ),
        )
    );
  }




  @override
  void dispose() {
    _added = null;
    showDetails = null;
    super.dispose();
  }

  // void _updateRating(TVShowDetails show) {
  //   FirebaseFirestore.instance
  //       .collection("${auth.currentUser.email}")
  //       .doc("shows")
  //       .collection("watched_shows")
  //       .doc(show.id.toString())
  //       .update(
  //           {"rating" : show.rating}
  //       );
  // }

}