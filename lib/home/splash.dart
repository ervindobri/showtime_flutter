import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../main.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Stream<QuerySnapshot> _watchedShowsStream;
  // Stream<QuerySnapshot> _allWatchedShowsStream;



  StreamSubscription<ConnectivityResult> subscription;
  var connectionStatus;

  Future<List<List<Episode>>> _scheduledEpisodes;
  List<int> watchedShowIdList = [];

  SessionUser currentUser = SessionUser();

  bool allDone = false;
  Future<SessionUser> _currentUserObject;

  List<Episode> notAiredList = [];


  @override
  void initState() {
    super.initState();
    //Listen to actve/inactive connection
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result;
      });
    });

    _currentUserObject = FirestoreUtils().getUserData();


    //TODO: add splash screen timer, and check every sec if all tasks finished
    // if ( auth.currentUser != null){
    //   _watchedShowsStream = FirebaseFirestore.instance
    //       .collection("${auth.currentUser.email}/shows/watched_shows")
    //       .orderBy('lastWatched', descending: true)
    //       .snapshots();
    // }
  }

  @override
  void dispose() {
    // _allWatchedShowsStream = null;
    _watchedShowsStream = null;
    subscription = null;
    _currentUserObject = null;
    super.dispose();

  }

  bool checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
      return false;
    }
    else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    checkInternetConnectivity();


    print("splash");
    return Scaffold(
      body: Container(
          color: bgColor,
          child: Column(
            children: [
              //ANIMATE IN LOGO
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 50),
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    width: _width / 2,
                    height: _height / 5.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/showTIMEsmall.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              // PROGRESS BAR TO LOAD HOME STUFF
              FutureBuilder(
                future: _currentUserObject,
                builder: (context, uSnapshot) {
                 if  (uSnapshot.hasData) currentUser = uSnapshot.data;
                 print("current user: $currentUser");
                 _watchedShowsStream = FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots();
                  return StreamBuilder(
                    stream: _watchedShowsStream,
                    builder: (context, snapshot) {
                      if ( snapshot.hasData){
                        print("data");
                        print("done");
                        watchedShowIdList.clear();
                        watchedShowList.clear();
                        // allWatchedShows.clear();
                        snapshot.data.documents
                            .forEach((f) {
                          // print(f.data);
                          watchedShowIdList.add(int.parse(f.documentID));
                          WatchedTVShow show = new WatchedTVShow(
                              id: f.documentID,
                              name:
                              f.data()['name'],
                              startDate: f.data()[
                              'start_date'],
                              runtime: f.data()[
                              'runtime'],
                              imageThumbnailPath: f.data()[
                              'image_thumbnail_path'],
                              totalSeasons: f.data()[
                              'total_seasons'],
                              episodePerSeason: f.data()[
                              'episodesPerSeason'],
                              currentSeason: f.data()[
                              'currentSeason'],
                              currentEpisode: f.data()[
                              'currentEpisode'],
                              firstWatchDate: f.data()[
                              'startedWatching'],
                              rating: f.data()['rating'],
                              lastWatchDate:
                              f.data()['lastWatched'],
                              favorite: f.data()['favorite'] ?? false);
                          watchedShowList.add(show);
                          // allWatchedShows.add(show);
                        });
                        _scheduledEpisodes = FirestoreUtils().getEpisodeList(watchedShowIdList);
                        print(watchedShowList.length);
                      }

                      return FutureBuilder(
                        future: _scheduledEpisodes,
                        builder: (context, snapshot) {
                          if ( snapshot.hasData){
                            print("loading scheduled episodes");
                            for(int index=0 ; index < 5; index++){
                                scheduledEpisodes.add(snapshot.data[index]);
                                int notAired = snapshot.data[index].length - 1;
                                for(int i=0; i< snapshot.data[index].length ; i++){
                                  if ( !snapshot.data[index][i].aired()){
                                    notAired = i;
                                    break;
                                  }
                                }
                                notAiredList.add(snapshot.data[index][notAired]);
                            }
                            // print(notAiredList.length);
                            Timer.run(() {
                              final home = HomeView(
                                user: currentUser,
                                notAiredList: notAiredList,
                                watchedShowsList: watchedShowList,
                              );
                              Navigator.of(context)
                                  .pushAndRemoveUntil(CupertinoPageRoute(
                                builder: (context) => home,
                              ),(route) => false);
                            });
                          }
                          return Center(
                            child: Container(
                              width: _width*.5,
                              height: _height/4,
                              // color: Colors.black,
                              child: Center(
                                child: FlareActor("assets/loadingcouch.flr",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    animation: "load"),
                              ),
                            ),
                          );
                        }
                      );
                    }
                  );
                }
              ),
            ],
          ),
      ),
    );
  }
}
