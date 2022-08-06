import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:show_time/core/constants/custom_variables.dart';
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
  getDetailResults({required TVShow show}) =>
      new Network().getDetailResults(show: show);

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

    return InkWell(
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
        child: Column(
          children: [
            Container(
              height: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'thumbnail-${widget.show.name}',
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: GlobalColors.bgColor,
                        image: DecorationImage(
                            image:
                                NetworkImage(widget.show.imageThumbnailPath!),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: new Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          children: [
                            Container(
                              width: 150,
                              child: AutoSizeText(
                                widget.show.name!,
                                maxLines: 2,
                                style: Get.textTheme.bodyText1!.copyWith(
                                    color: GlobalColors.greyTextColor),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: GlobalColors.greyTextColor,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Text(
                                        "${widget.show.runtime}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w700,
                                          fontSize: _width / 25,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: GlobalColors.fireColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: Text(
                                              "${widget.show.rating == 0 ? r"N\A" : widget.show.rating}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w700,
                                                fontSize: _width / 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: GetBuilder<UIController>(
                                      init: uiController,
                                      builder: (uiController) {
                                        return TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    GlobalColors.primaryBlue),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            print(_added);
                                            if (!_added) {
                                              var show = FirestoreUtils()
                                                  .addToWatchedShows(
                                                      showDetails);
                                              GlobalVariables.watchedShowList
                                                  .add(show);
                                              setState(() {
                                                _added = true;
                                              });
                                              uiController.showToast(
                                                  context: context,
                                                  text: "Show added!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  color:
                                                      GlobalColors.primaryBlue,
                                                  icon: Icons.done);
                                            } else {
                                              //FOR UPDATING SHOWS RATING
                                              // _updateRating(showDetails);
                                              uiController.showToast(
                                                  context: context,
                                                  text:
                                                      "${widget.show.name} already added!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  icon: Icons.info,
                                                  color:
                                                      GlobalColors.primaryBlue);
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
                ],
              ),
            ),
            Divider(height: 1, color: GlobalColors.greyTextColor),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
