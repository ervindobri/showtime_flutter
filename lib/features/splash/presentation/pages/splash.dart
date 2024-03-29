// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/controllers/auth_controller.dart';
import 'package:show_time/controllers/storage_controller.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/splash/bloc/splash_bloc.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/providers/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AnimationMixin {
  ConnectivityStatus connectionStatus = ConnectivityStatus.wiFi;
  bool allDone = false;
  List<Episode> notAiredList = [];

  var animationName = 'Shrink';
  late Animation<double> animation;
  late AnimationController _controller;
  bool allCompleted = false;
  late QuerySnapshot watchedShowsSnapshot;
  List<WatchedTVShow> watchedShowsList = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // //Fetch current user and show data
    // authController.getUserData();
    // showController.initialize();
    print("splash init");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.bgColor,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Container(
        width: _width,
        color: GlobalColors.bgColor,
        height: _height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //ANIMATE IN LOGO
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Hero(
                  tag: 'logo',
                  child: InkWell(
                    onTap: () {
                      // context.read<SplashBloc>().add(GetSplashEvent(true));
                      print("Get splash event!");
                    },
                    child: Container(
                      width: kIsWeb ? 200 : _width / 2,
                      height: kIsWeb ? 150 : _height * .15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/showTIMEsmall.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // PROGRESS BAR TO LOAD HOME STUFF
            splashBody(_width, _height, context),
          ],
        ),
      ),
    );
  }

  Widget splashBody(double _width, double _height, BuildContext context) {
    if (connectionStatus == ConnectivityStatus.offline) {
      return SizedBox(
        width: _width,
        height: _height * .6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.exclamationCircle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "No internet connection",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) async {
      if (state is SplashInitial) {
        print("Check if loaded!");
        //check if loaded
      } else if (state is SplashError) {
        print("Splash listener: Error");
      } else if (state is SplashLoaded) {
        final email = await sl<StorageController>().read(key: 'email');
        sl<AuthController>().currentUserEmail.value = email;
        NavUtils.navigateReplaced(context, '/home');
      }
    }, builder: (context, SplashState state) {
      print(state);
      if (state is SplashInitial) {
        return const LoadingCouch();
      } else if (state is SplashLoading) {
        return const LoadingCouch();
      } else if (state is SplashLoaded) {
        return const LoadingCouch();
      } else {
        //todo: ERROR
        return const Text("Could not fetch show datas!");
      }
    });
  }
}
