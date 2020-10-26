import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:flutter/cupertino.dart';


class WatchedTVShow extends TVShowDetails{

  int currentSeason;
  int currentEpisode;
  String firstWatchDate;
  String lastWatchDate;
  bool favorite;
  Map<String, dynamic> criteriaMap ;


  WatchedTVShow({
    id,
    name,
    startDate,
    imageThumbnailPath,
    runtime,
    rating,
    episodes,
    totalSeasons,
    episodePerSeason,
    this.currentSeason,
  this.currentEpisode,
  this.firstWatchDate,
  this.lastWatchDate,
  this.criteriaMap,
  this.favorite}):
        super(id: id,
        name: name,
          startDate: startDate,
          runtime : runtime,
          rating : rating,
          imageThumbnailPath: imageThumbnailPath,
          episodes:  episodes,
          totalSeasons : totalSeasons,
      episodePerSeason : episodePerSeason);

  bool hasMoreEpisodes(){
    bool flag = false;
    scheduledEpisodes.forEach((show) {
      // print("${show[0].embedded['show']['id']} == ${this.id}");
        if ( show[0].embedded['show']['id'].toString() == this.id){
          flag = true;
        }
    });
    return flag;
  }

  int stopWatch(){
    var firstWatched = DateTime.parse("$firstWatchDate");
    var lastWatched  = DateTime.parse("$lastWatchDate");
    int diffDays = lastWatched.difference(firstWatched).inDays;
    return diffDays.abs();
  }

  int diffDays(){
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    return diffDays;
  }

  nextEpisodeAirDate(){
    if ( calculateWatchedEpisodes() > 0){
      if ( this.episodes[calculateWatchedEpisodes() -1 ].airDate != ""){
        var airDate = DateTime.parse("${this.episodes[calculateWatchedEpisodes() - 1]?.airDate} 12:00:00.000");
        var diff = airDate.difference(DateTime.now());
        return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
      }
    }
    return [Duration(days: 0), DateTime.now()];
  }
  bool nextEpisodeAired(){
    return nextEpisodeAirDate()[0].inDays < 0;
  }

  int calculateWatchedEpisodes(){
    int watchedEpisodes = 0;
    this.episodePerSeason.forEach((key, value) {
      if ( int.parse(key) < currentSeason){
        watchedEpisodes += value;
      }
      else if( currentSeason == int.parse(key)){
        watchedEpisodes += currentEpisode;
      }
    });
    return watchedEpisodes;
  }
  int calculateTotalEpisodes(){
    int totalEpisodes = 0;
    this.episodePerSeason.forEach((key, value) {
      totalEpisodes += value;
    });
    return totalEpisodes;
  }
  double calculateProgress() {
    int watchedEpisodes = calculateWatchedEpisodes();

    int totalEpisodes = calculateTotalEpisodes();

//    print("total: ${totalEpisodes} watched: ${watchedEpisodes}");
    return (watchedEpisodes / totalEpisodes);
  }

   incrementEpisodeWatch() {
     print(currentEpisode);
     if ( currentSeason < totalSeasons){
       if(currentEpisode < episodePerSeason[currentSeason.toString()] ){
         currentEpisode++;
       }
       else{
         //do nothing
         currentSeason++;
         currentEpisode = 1;
       }
     }
     else{
       if(currentEpisode < episodePerSeason[currentSeason.toString()] ){
         currentEpisode++;
       }
     }

  }


  @override
  String toString() {
    return 'WatchedTVShow{currentSeason: $currentSeason, currentEpisode: $currentEpisode, firstWatchDate: $firstWatchDate, lastWatchDate: $lastWatchDate, favorite: $favorite, criteriaMap: $criteriaMap}';
  }

  setLastWatchedDate() {
    var mZero = DateTime.now().month < 10 ? "0" : "";
    var dZero = DateTime.now().day < 10 ? "0" : "";
    this.lastWatchDate = DateTime.now().year.toString() + "-" + mZero + DateTime.now().month.toString() +
        "-" + dZero + DateTime.now().day.toString();
  }
  factory WatchedTVShow.fromJson(Map <String, dynamic> json){
    // print(json['runtime']);

    return WatchedTVShow(
        name : json['name'],
        startDate : json['start_date'],
        runtime : json['runtime'] ??  0,
        rating : json['rating'] ?? 0.0,
        imageThumbnailPath : json['image_thumbnail_path'],
        totalSeasons : json['total_seasons'],
        episodePerSeason : json['episodesPerSeason'],
        currentSeason : json['currentSeason'],
        currentEpisode : json['currentEpisode'],
        firstWatchDate : json['startedWatching'],
        lastWatchDate : json['lastWatched'],
        favorite: json['favorite'] ?? false
    );
  }
  factory WatchedTVShow.fromFirestore(Map <String, dynamic> json, dynamic collId){
    // print(json['runtime']);

    return WatchedTVShow(
        id: collId,
        name : json['name'],
        startDate : json['start_date'],
        runtime : json['runtime'] ??  0,
        rating : json['rating'] ?? 0.0,
        imageThumbnailPath : json['image_thumbnail_path'],
        totalSeasons : json['total_seasons'],
        episodePerSeason : json['episodesPerSeason'],
        currentSeason : json['currentSeason'],
        currentEpisode : json['currentEpisode'],
        firstWatchDate : json['startedWatching'],
        lastWatchDate : json['lastWatched'],
        favorite: json['favorite'] ?? false
    );
  }
}



