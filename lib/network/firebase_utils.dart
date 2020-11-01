import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/models/watched.dart';

import '../main.dart';

//TODO: REFACTOR FIRESTORE- CODE USAGES

class FirestoreUtils{
  final CollectionReference watchedShows = FirebaseFirestore.instance.collection('${auth.currentUser.email}/shows/watched_shows');
  final CollectionReference favorites = FirebaseFirestore.instance.collection("${auth.currentUser.email}/shows/favorites");
  final CollectionReference searchHistory = FirebaseFirestore.instance.collection("${auth.currentUser.email}/shows/search_history");


  void addToFavorites(WatchedTVShow show){
    favorites.doc(show.id).set({
      "name": show.name,
      "start_date": show.startDate,
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
      var lastWatchDate = DateTime.now().year.toString() + "-" + mZero + DateTime.now().month.toString() +
          "-" + dZero + DateTime.now().day.toString();

      WatchedTVShow watchedShow = new WatchedTVShow(
          id: show.id,
          name : show.name,
          startDate : show.startDate,
          runtime : show.runtime,
          rating : show.rating,
          imageThumbnailPath : show.imageThumbnailPath,
          totalSeasons : show.totalSeasons,
          episodePerSeason : show.episodePerSeason,
          currentSeason : 1,
          currentEpisode : 0,
          firstWatchDate : lastWatchDate,
          lastWatchDate : lastWatchDate,
          favorite: false
      );

      if ( show.isSafe() ){
        watchedShows.doc(show.id.toString()).set({
          "name": show.name,
          "start_date": show.startDate,
          "runtime": show.runtime,
          "rating" : show.rating,
          "favorite" : false,
          "image_thumbnail_path": show.imageThumbnailPath,
          "total_seasons": show.totalSeasons,
          "episodesPerSeason": show.episodePerSeason,
          "currentSeason": 1,
          "currentEpisode": 1,
          "startedWatching": lastWatchDate,
          "lastWatched": lastWatchDate});
      }
      return watchedShow;
    }
    catch (e) {
      print("Error setting Watched Shows data! $e");
    }
  }


  Future<bool> checkIfShowExists(String showID) async {
    final docSnapshot = await watchedShows.doc(showID).get();
    return docSnapshot.exists;
  }

  void favoriteShow(WatchedTVShow show, bool value){
    watchedShows
        .doc(show.id.toString())
        .update({
      "favorite" : value
    });
  }

  void deleteFromFavorites(WatchedTVShow show) {
    favorites.doc(show.id.toString()).delete();
  }
  Future<dynamic> getWatchedShowData(String showID){
    return watchedShows.doc(showID).get();
  }

  Future<void> setSearchHistory(String value) {
    String date = DateTime.now().year.toString()  + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString() + "-" + DateTime.now().hour.toString() + "-" + DateTime.now().minute.toString();
    return searchHistory.doc(value).set({
      "term": value,
      "date" : date
    });
  }

  getSearchHistory() {
    return searchHistory.orderBy('date',descending: true).limit(6).snapshots();
  }
}

