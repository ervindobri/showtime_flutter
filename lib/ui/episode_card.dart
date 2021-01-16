import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eWoke/models/episode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EpisodeCard extends StatefulWidget {
  final Episode episode;

  EpisodeCard({this.episode});
  @override
  _EpisodeCardState createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {

  bool _tapped;


  @override
  void initState() {
    _tapped = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));

    //TODO: ADD SPOILER WARNING TO THE EPISODES NOT YET WATCHED

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tapped = !_tapped;
          });
          // print(_tapped);
        },
        child: Container(
          width: _width / 1.4,
          height: _height / 6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _radius,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 5,
                    spreadRadius: -2,
                    offset: Offset(2, 3)),
              ]),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                widget.episode.image,
                imageBuilder: (context, image) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: _radius,
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              widget.episode.aired()
                  ?  Visibility(
                visible: !_tapped,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: _width / 1.4,
                      height: _height / 3,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        borderRadius:_radius,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: AutoSizeText(
                                widget.episode.name,
                                maxLines: 2,
                                maxFontSize: 20,
                                minFontSize: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: _width/3
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        widget.episode.season.toString(),
                                        maxLines: 3,
                                        maxFontSize: 30,
                                        minFontSize: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _width/3,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w700

                                        ),
                                      ),
                                      AutoSizeText(
                                        "Season",
                                        maxLines: 3,
                                        maxFontSize: 22,
                                        minFontSize: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _width/3,
                                            fontWeight: FontWeight.w100,
                                          fontFamily: 'Raleway',


                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        widget.episode.episode.toString(),
                                        maxLines: 3,
                                        maxFontSize: 30,
                                        minFontSize: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _width/3,
                                            fontWeight: FontWeight.w700,
                                          fontFamily: 'Raleway'

                                        ),
                                      ),
                                      AutoSizeText(
                                        "Episode",
                                        maxLines: 3,
                                        maxFontSize: 22,
                                        minFontSize: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _width/3,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w100
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: AutoSizeText(
                                widget.episode.airDate,
                                maxLines: 1,
                                maxFontSize: 15,
                                minFontSize: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: _width/3
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  :  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                            width: _width / 1.4,
                            height: _height / 3,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.66),
                            borderRadius: _radius,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "This apisode is not yet released!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: _width/25,
                                  ),
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.exclamationCircle,
                                color: Colors.white,
                                size: 50,
                              )
                            ],
                          ),
                        ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );

  }
}
