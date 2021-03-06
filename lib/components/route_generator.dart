import 'package:show_time/pages/splash.dart';
import 'package:show_time/screens/browse_shows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        // if ( args is UserDao){
        //   return MaterialPageRoute(builder: (_) => LoginScreen());
        // }
        break;
      case AllTVShows.routeName:
        print("pushed BROWSE!");
        return MaterialPageRoute(builder: (_) => AllTVShows());
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}