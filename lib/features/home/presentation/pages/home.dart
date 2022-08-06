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
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AnimationMixin {
  @override
  Widget build(BuildContext context) {
    final email = sl<AuthRepository>().userCredential?.user?.email;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: sl<WatchedShowsBloc>()
                    ..add(LoadWatchedShowsEvent(email)),
                ),
                BlocProvider.value(
                  value: sl<ScheduledShowsBloc>()
                    ..add(
                      LoadScheduledShowsEvent(),
                    ),
                ),
              ],
              child: homeScreenBody(context),
            ),
            const Positioned(
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50 + 42 + 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Shimmer.fromColors(
                            highlightColor: GlobalColors.primaryGreen,
                            baseColor: GlobalColors.primaryBlue,
                            direction: ShimmerDirection.ltr,
                            period: const Duration(seconds: 10),
                            child: Container(
                              height: _height * 0.07,
                              width: kIsWeb ? _width * .5 : _width * .8,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0)),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      GlobalColors.primaryGreen,
                                      GlobalColors.primaryBlue,
                                    ]),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              showGreetings(),
                              style: const TextStyle(
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
                  const SizedBox(height: 16),
                  DiscoverContent(),
                  const SizedBox(height: 16),
                  ScheduledContent(),
                ],
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
    return greetings + ", Ervin!";
  }
}
