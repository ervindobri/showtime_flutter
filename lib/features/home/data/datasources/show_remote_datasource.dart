import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/error/exceptions.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:http/http.dart';

abstract class ShowRemoteDataSource {
  Future<dynamic> getScheduledShows();
  Future<dynamic> getWatchedShows(String email);

  List<WatchedTVShow>? watchedShows;
  Set<int>? watchedShowIds;
  List<Episode>? notAiredList;
  List<WatchedTVShow>? sortedList;
}

class ShowRemoteDataSourceImpl extends ShowRemoteDataSource {
  final FirebaseFirestore firestore;
  ShowRemoteDataSourceImpl({required this.firestore});

  @override
  Future<dynamic> getScheduledShows() async {
    try {
      EpisodeList allEpisodes = await _getScheduledEpisodesFromUrl();
      List<List<Episode>> list = [];

      //to avoid duplicates
      watchedShowIds!.toList().forEach((id) {
        List<Episode> current = [];
        allEpisodes.episodes.forEach((episode) {
          if (episode.embedded!['show']['id'] == id) {
            current.add(episode);
          }
        });
        if (current.length > 0) {
          list.add(current);
        }
      });

      //Sort by airdate instead id
      list.sort((a, b) => a[0].airDate!.compareTo(b[0].airDate!));
      list = list.toSet().toList();
      final scheduled = list;
      List<Episode> episodes = [];
      for (int index = 0; index < scheduled.length; index++) {
        int notAired = scheduled[index].length - 1;
        for (int i = 0; i < scheduled[index].length; i++) {
          if (!scheduled[index][i].aired()) {
            notAired = i;
            break;
          }
        }
        episodes.add(scheduled[index][notAired]);
      }
      episodes.sort((a, b) => a.airDate!.compareTo(b.airDate!));
      episodes = episodes.toSet().toList();
      notAiredList = [...episodes];
      return notAiredList;
    } catch (e) {
      print(e);
      throw CustomServerException("");
    }
  }

  @override
  Future<dynamic> getWatchedShows(String email) async {
    try {
      CollectionReference watchedShowsRef =
          firestore.collection('${email}/shows/watched_shows');
      List<WatchedTVShow> result = [];
      watchedShowIds = {};
      await watchedShowsRef.get().then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              //somehow duplicates get in FFS
              watchedShowIds!.add(int.parse(doc.id));
              WatchedTVShow show = new WatchedTVShow.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id);
              result.add(show);
            })
          });
      watchedShows = [...result];
      sortedList = [...watchedShows!];
      return sortedList;
    } catch (e) {
      print(e);
      throw CustomServerException("");
    }
  }

  void getNotAired() {}

  _getScheduledEpisodesFromUrl() async {
    var searchURL = GlobalVariables.FULL_SCHEDULE_URL;
    final response = await get(Uri.parse(searchURL));
    if (response.statusCode == 200) {
      return EpisodeList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }
}
