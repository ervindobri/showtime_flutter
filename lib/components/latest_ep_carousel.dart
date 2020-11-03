import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/ui/episode_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LatestEpisodesCarousel extends StatefulWidget {
  final TVShowDetails show;

  LatestEpisodesCarousel({this.show});


  @override
  _LatestEpisodesCarouselState createState() => _LatestEpisodesCarouselState();
}

class _LatestEpisodesCarouselState extends State<LatestEpisodesCarousel> {




  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            height: _width * .58,
            child: CarouselSlider.builder(
              itemCount: widget.show.episodes.reversed.toList().take(10).length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return EpisodeCard(episode: widget.show.episodes.reversed.toList()[itemIndex]);
              },
              options: CarouselOptions(
                height: _width * .56,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
          ),
        ));

  }
}
