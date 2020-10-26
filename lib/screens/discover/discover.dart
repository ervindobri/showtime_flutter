import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/screens/discover/MostPopularShows.dart';
import 'file:///C:/Users/Winter/IdeaProjects/eWoke/lib/screens/discover/discover_contents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPageRoute extends CupertinoPageRoute {
  final List list;
  SecondPageRoute({ this.list})
      : super(builder: (BuildContext context) => new DiscoverRoute(data: list));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
 // @override
 // Widget buildPage(BuildContext context, Animation<double> animation,
 //     Animation<double> secondaryAnimation) {
 //   return new FadeTransition(opacity: animation, child: new DiscoverRoute(data: list));
 // }
}


final Map<String, dynamic> discoverMap = {
  "Overall Progress": MostPopularShows(),
  "Most popular shows": MostPopularShows(),
  "Watchlist": DiscoverWatchList(),
  "Favorites": MostPopularShows()
};

class DiscoverRoute extends StatelessWidget {
  final List data;

  const DiscoverRoute({Key key, this.data}) : super(key: key);

  _selectDiscoverContent(data) {
    print(data);
    return discoverMap[data];
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return _selectDiscoverContent(data[0]); //pass title, and get content
  }
}
