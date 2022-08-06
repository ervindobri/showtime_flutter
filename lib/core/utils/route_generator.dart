import 'package:show_time/features/authentication/presentation/pages/login.dart';
import 'package:show_time/features/home/presentation/pages/home.dart';
import 'package:show_time/features/splash/presentation/pages/splash.dart';
import 'package:show_time/features/browse/presentation/pages/browse_shows.dart';
import 'package:flutter/material.dart';
import 'package:show_time/features/watchlist/presentation/pages/watchlist.dart';
import 'package:show_time/screens/discover/most_popular_shows.dart';
import 'package:show_time/screens/discover/progress.dart';
import 'package:show_time/screens/full_schedule.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/discover_0':
        return MaterialPageRoute(builder: (_) => const OverallProgress());
      case '/discover_1':
        return MaterialPageRoute(builder: (_) => const MostPopularShows());
      case '/discover_2':
        return MaterialPageRoute(builder: (_) => const WatchlistWrapper());
      case '/discover_3':
        return MaterialPageRoute(builder: (_) => const MostPopularShows());
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/schedule':
        return MaterialPageRoute(builder: (_) => const FullSchedule());

      case '/search_shows':
        return MaterialPageRoute(builder: (_) => const AllTVShows());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
