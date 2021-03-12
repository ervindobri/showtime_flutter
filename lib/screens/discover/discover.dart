import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/screens/discover/most_popular_shows.dart';
import 'package:show_time/screens/discover/watchlist.dart';
import 'package:show_time/screens/discover/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPageRoute extends CupertinoPageRoute {
  final List list;
  SecondPageRoute({ required this.list}) : super(builder: (BuildContext context) => new DiscoverRoute(list: list));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
 @override
 Widget buildPage(BuildContext context, Animation<double> animation,
     Animation<double> secondaryAnimation) {
   return new FadeTransition(opacity: animation, child: new DiscoverRoute(list: list));
 }
}


class DiscoverRoute extends StatelessWidget {
  final List list;

  const DiscoverRoute({Key? key, required this.list}) : super(key: key);

  _selectDiscoverContent(data) {
    // print(data);
    return GlobalVariables.discoverMap[data];
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return _selectDiscoverContent(list[0]); //pass title, and get content
  }
}
