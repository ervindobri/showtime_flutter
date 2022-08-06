import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/features/authentication/domain/repositories/auth_repo.dart';
import 'package:show_time/features/authentication/presentation/pages/login.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/home/presentation/pages/home.dart';
import 'package:show_time/features/splash/presentation/pages/splash.dart';
import 'package:show_time/features/browse/presentation/pages/browse_shows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:show_time/features/watchlist/presentation/pages/watchlist.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/screens/discover/most_popular_shows.dart';
import 'package:show_time/screens/discover/progress.dart';
import 'package:show_time/screens/full_schedule.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/discover_0':
        return MaterialPageRoute(builder: (_) => OverallProgress());
      case '/discover_1':
        return MaterialPageRoute(builder: (_) => MostPopularShows());
      case '/discover_2':
        final email = sl<AuthRepository>().userCredential?.user?.email;

        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      sl<WatchedShowsBloc>()..add(LoadWatchedShowsEvent(email)),
                  child: DiscoverWatchList(),
                ));
      case '/discover_3':
        return MaterialPageRoute(builder: (_) => MostPopularShows());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/schedule':
        return MaterialPageRoute(builder: (_) => FullSchedule());

      case '/search_shows':
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