import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/authentication/domain/repositories/auth_repo.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/home/presentation/widgets/custom_appbar.dart';
import 'package:show_time/features/home/presentation/widgets/home_sections/discover_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_sections/scheduled_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_sliding_panel.dart';
import 'package:flutter/material.dart';
import 'package:show_time/injection_container.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AnimationMixin {
  //GetX

  var _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    final email = sl<AuthRepository>().userCredential?.user?.email;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // new line
      key: _drawerKey,
      backgroundColor: GlobalColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      sl<WatchedShowsBloc>()..add(LoadWatchedShowsEvent(email)),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<ScheduledShowsBloc>()..add(LoadScheduledShowsEvent()),
                ),
              ],
              child: homeScreenBody(context),
            ),
            Positioned(
              top: 0,
              child: CustomAppbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeScreenBody(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: _height,
            color: GlobalColors.bgColor,
            child: Scrollbar(
              isAlwaysShown: kIsWeb ? true : false,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //TODO: shimmer not working on web
                            Shimmer.fromColors(
                              highlightColor: GlobalColors.greenColor,
                              baseColor: GlobalColors.blueColor,
                              direction: ShimmerDirection.ltr,
                              period: const Duration(seconds: 10),
                              child: Container(
                                height: _height * 0.07,
                                width: kIsWeb ? _width * .5 : _width * .8,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        GlobalColors.greenColor,
                                        GlobalColors.blueColor,
                                      ]),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                showGreetings(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<WatchedShowsBloc, WatchedShowsState>(
                      builder: (context, state) {
                        print(state);
                        return DiscoverContent();
                      },
                    ),
                    ScheduledContent(),
                    Container(
                      height: 200,
                      width: _width,
                    )
                  ],
                ),
              ),
            ),
          ),
          HomeSlidingPanel(),
        ],
      ),
    );
  }

  //TODO: get from auth repo
  String showGreetings() {
    var timeNow = DateTime.now().hour;
    String greetings = "";
    if (timeNow <= 12) {
      greetings = 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetings = 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      greetings = 'Good Evening';
    } else {
      greetings = 'Good Night';
    }
    // print(firstName);
    return greetings + ", User!";
  }
}
