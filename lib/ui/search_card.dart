import 'dart:ui';
import 'package:get/get.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/ui_controller.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/screens/detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';

class ShowCard extends StatefulWidget {
  final TVShow show;
  const ShowCard({Key? key, required this.show}) : super(key: key);

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> with AnimationMixin {
  late TVShowDetails showDetails;

  bool _added = false;
  UIController uiController = Get.put(UIController())!;
  getDetailResults({required TVShow show}) => new Network().getDetailResults(show: show);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfAdded();
    _getShowDetails();
  }

  _checkIfAdded() async {
    var res = await FirestoreUtils().checkIfShowExists(widget.show.id);
    setState(() {
      _added = res;
    });
  }

  _getShowDetails() async {
//    print("getting details: ${widget.show.name}");
    showDetails = await getDetailResults(show: widget.show);
  }

  @override
  void didUpdateWidget(ShowCard oldWidget) {
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
      bottomLeft: Radius.circular(25.0),
      bottomRight: Radius.circular(25.0),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return DetailView(show: showDetails);
                },
                isScrollControlled: true);
          },
          child: Hero(
              tag: 'thumbnailPhoto${widget.show.id}',
              child: Container(
                width: _width * .3,
                height: _height / 1.7,
                constraints: BoxConstraints(
                    maxWidth: _width * 0.7, maxHeight: _height / 1.7),
                decoration: BoxDecoration(
                  color: GlobalColors.bgColor,
                  image: DecorationImage(
                      image: NetworkImage(widget.show.imageThumbnailPath!),
                      fit: BoxFit.fill),
                  borderRadius: _radius,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        blurRadius: 5.0,
                        spreadRadius: -2,
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
                            filter: new ImageFilter.blur(
                                sigmaX: 10.0, sigmaY: 10.0),
                            child: new Container(
                              width: _width,
                              height: _height / 6,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: _width / 4,
                                                  height: _height / 25,
                                                  decoration: BoxDecoration(
                                                    color: GlobalColors.greyTextColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25.0),
                                                      topRight:
                                                          Radius.circular(25.0),
                                                      bottomLeft:
                                                          Radius.circular(25.0),
                                                      bottomRight:
                                                          Radius.circular(25.0),
                                                    ),
                                                    boxShadow: [
                                                      new BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.1),
                                                          blurRadius: 15.0,
                                                          spreadRadius: 3,
                                                          offset: Offset(0, 0)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        "Runtime",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: _width/ 25,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.show.runtime}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: _width/ 25,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: _width/4,
                                                  height: _height/25,
                                                  decoration: BoxDecoration(
                                                    color: GlobalColors.fireColor,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight:Radius.circular(25.0),
                                                      bottomLeft:Radius.circular(25.0),
                                                      bottomRight:Radius.circular(25.0),
                                                    ),
                                                    boxShadow: [
                                                      new BoxShadow(
                                                          color: Colors.black.withOpacity(.1),
                                                          blurRadius: 15.0,
                                                          spreadRadius: 3,
                                                          offset: Offset(0, 0)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          "Rating",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: _width / 25,
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "${widget.show.rating == 0 ? r"N\A" : widget.show.rating}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: _width/ 25,
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
                                            child: GetBuilder<UIController>(
                                              init: uiController,
                                              builder: (uiController) {
                                                return FlatButton(
                                                  minWidth: _height / 13,
                                                  height: _height / 10,
                                                  color: GlobalColors.blueColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(20)),
                                                  ),
                                                  onPressed: () {
                                                    if (!_added) {
                                                      var show = FirestoreUtils()
                                                          .addToWatchedShows(
                                                          showDetails);
                                                      GlobalVariables
                                                          .watchedShowList.add(
                                                          show);
                                                      setState(() {
                                                        _added = true;
                                                      });
                                                      uiController.showAlert(
                                                          title: "Show added!",
                                                          seconds: 2,
                                                          blurPower: 5,
                                                          icon: Icons.done);
                                                    } else {
                                                      //FOR UPDATING SHOWS RATING
                                                      // _updateRating(showDetails);
                                                      uiController.showAlert(
                                                          title: "${widget.show
                                                              .name} already added!",
                                                          seconds: 2,
                                                          blurPower: 5,
                                                          icon: Icons.done);
                                                    }
                                                  },
                                                  child: FaIcon(
                                                    FontAwesomeIcons.couch,
                                                    color: Colors.white,
                                                    size: _height / 17,
                                                  ),
                                                );
                                              }),
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
                ),
              )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
