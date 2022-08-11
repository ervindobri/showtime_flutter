import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/main.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:show_time/models/user.dart';
import 'package:show_time/features/home/data/models/watched.dart';

import 'network.dart';

//TODO: REFACTOR FIRESTORE- CODE USAGES

class FirestoreUtils {
  CollectionReference watchedShows = FirebaseFirestore.instance.collection(
      '${auth.currentUser?.email ?? "dobriervin@yahoo.com"}/shows/watched_shows');
  CollectionReference favorites = FirebaseFirestore.instance.collection(
      "${auth.currentUser?.email ?? "dobriervin@yahoo.com"}/shows/favorites");
  CollectionReference searchHistory = FirebaseFirestore.instance.collection(
      "${auth.currentUser?.email ?? "dobriervin@yahoo.com"}/shows/search_history");
  DocumentReference userProfile = FirebaseFirestore.instance
      .doc("${auth.currentUser?.email ?? "dobriervin@yahoo.com"}/user");
  final Duration loginTime = const Duration(milliseconds: 600);

  Stream<QuerySnapshot<Object?>> get getWatchedShows =>
      watchedShows.orderBy('lastWatched', descending: true).snapshots();

  void addToFavorites(WatchedTVShow show) {
    favorites.doc(show.id).set({
      "name": show.name,
      "start_date": show.startDateString,
      "runtime": show.runtime,
      "rating": show.rating,
      "image_thumbnail_path": show.imageThumbnailPath,
      "total_seasons": show.totalSeasons,
      "episodesPerSeason": show.episodePerSeason,
      "currentSeason": show.currentSeason,
      "currentEpisode": show.currentEpisode,
      "startedWatching": show.firstWatchDate,
      "lastWatched": show.lastWatchDate
    });
  }

  addToWatchedShows(TVShowDetails show) {
    try {
      var mZero = DateTime.now().month < 10 ? "0" : "";
      var dZero = DateTime.now().day < 10 ? "0" : "";
      var lastWatchDate = DateTime.now().year.toString() +
          "-" +
          mZero +
          DateTime.now().month.toString() +
          "-" +
          dZero +
          DateTime.now().day.toString();

      if (show.isSafe()) {
        watchedShows.doc(show.id.toString()).set({
          "name": show.name,
          "start_date": show.startDateString,
          "runtime": show.runtime,
          "rating": show.rating,
          "favorite": false,
          "image_thumbnail_path": show.imageThumbnailPath,
          "total_seasons": show.totalSeasons,
          "episodesPerSeason": show.episodePerSeason,
          "currentSeason": 1,
          "currentEpisode": 1,
          "startedWatching": lastWatchDate,
          "lastWatched": lastWatchDate
        });
      }
      return  WatchedTVShow.fromDetails(show);
    } catch (e) {
      print("Error setting Watched Shows data! $e");
    }
  }

  Future<bool> checkIfShowExists(String showID) async {
    final docSnapshot = await watchedShows.doc(showID).get();
    return docSnapshot.exists;
  }

  Future<bool> isFavorite(String showID) async {
    final docSnapshot = await favorites.doc(showID).get();
    return docSnapshot.exists;
  }

  void favoriteShow(WatchedTVShow show, bool value) {
    watchedShows.doc(show.id.toString()).update({"favorite": value});
  }

  void deleteFromFavorites(WatchedTVShow show) {
    favorites.doc(show.id.toString()).delete();
  }

  Future<dynamic> getWatchedShowData(String showID) {
    return watchedShows.doc(showID).get();
  }

  Future<void> setSearchHistory(String value) {
    String date = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString() +
        "-" +
        DateTime.now().hour.toString() +
        "-" +
        DateTime.now().minute.toString();
    return searchHistory.doc(value).set({"term": value, "date": date});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSearchHistory() {
    return searchHistory.orderBy('date', descending: true).limit(6).snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<List<List<Episode>>> getEpisodeList(
      List<int> watchedShowIdList) async {
    // print("user - ${auth.currentUser.email} - id list: ${watchedShowIdList.length}");
    EpisodeList episodes = await Network().getScheduledEpisodes();
    List<List<Episode>> list = [];

    //to avoid duplicates
    watchedShowIdList.toSet().toList().forEach((id) {
      List<Episode> current = [];
      for (var episode in episodes.episodes) {
        if (episode.embedded!['show']['id'] == id) {
          current.add(episode);
        }
      }
      if (current.isNotEmpty) {
        list.add(current);
      }
    });

    //Sort by airdate instead id
    list.sort((a, b) => a[0].airDate!.compareTo(b[0].airDate!));
    list = list.toSet().toList();
    // print("Scheduled shows:${list.length}");
    return list;
  }

  updateEpisode(WatchedTVShow show) {
    watchedShows.doc(show.id.toString()).update({
      "name": show.name,
      "start_date": show.startDateString,
      "poster": show.imageThumbnailPath,
      "seasons": show.totalSeasons,
      "episodesPerSeason": show.episodePerSeason,
      "currentSeason": show.currentSeason,
      "currentEpisode": show.currentEpisode,
      "startedWatching": show.firstWatchDate,
      "lastWatched": show.lastWatchDate,
      "favorite": show.favorite
    });
  }

  void incrementWatchedTime(WatchedTVShow show) {
    watchedShows.doc(show.id.toString()).update({
      "watchedTimes": show.watchedTimes,
      "currentEpisode": 0,
      "currentSeason": 1,
    });
  }

  void updateUserInfo(SessionUser currentUser) {
    userProfile.set({
      'age': currentUser.age,
      'sex': currentUser.sex,
      'id': currentUser.id,
      'lastName': currentUser.lastName,
      'firstName': currentUser.firstName
    });
  }
}
