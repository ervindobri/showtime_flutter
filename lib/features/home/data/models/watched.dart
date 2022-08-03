import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/models/tvshow_details.dart';


class WatchedTVShow extends TVShowDetails{

  int currentSeason;
  int currentEpisode;
  String? firstWatchDate;
  String? lastWatchDate;
  bool? favorite;
  Map<String, dynamic>? criteriaMap ;
  int watchedTimes;

  WatchedTVShow({
    id,
    name,
    startDate,
    imageThumbnailPath,
    runtime,
    rating,
    genres,
    episodes,
    totalSeasons,
    episodePerSeason,
    required this.currentSeason,
  required this.currentEpisode,
  this.firstWatchDate,
  this.lastWatchDate,
  this.criteriaMap,
  this.favorite,
  this.watchedTimes = 0}):
        super(id: id,
        name: name,
          startDate: startDate,
          runtime : runtime,
          rating : rating,
          genres : genres,
          imageThumbnailPath: imageThumbnailPath,
          episodes:  episodes,
          totalSeasons : totalSeasons,
      episodePerSeason : episodePerSeason);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedTVShow &&
          runtimeType == other.runtimeType &&
          currentSeason == other.currentSeason &&
          currentEpisode == other.currentEpisode &&
          firstWatchDate == other.firstWatchDate &&
          lastWatchDate == other.lastWatchDate &&
          favorite == other.favorite &&
          criteriaMap == other.criteriaMap &&
          watchedTimes == other.watchedTimes;

  @override
  int get hashCode =>
      currentSeason.hashCode ^
      currentEpisode.hashCode ^
      firstWatchDate.hashCode ^
      lastWatchDate.hashCode ^
      favorite.hashCode ^
      criteriaMap.hashCode ^
      watchedTimes.hashCode;

  bool hasMoreEpisodes(){
    bool flag = false;
    GlobalVariables.scheduledEpisodes.forEach((show) {
      // print("${show[0].embedded['show']['id']} == ${this.id}");
        if ( show[0].embedded!['show']['id'].toString() == this.id){
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
    if ( calculateWatchedEpisodes() == 0){
      if ( this.episodes![0].airDate != ""){
        var airDate = DateTime.parse("${this.episodes![0].airDate} 12:00:00.000");
        var diff = airDate.difference(DateTime.now());
        return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
      }
    }
    else if ( calculateWatchedEpisodes() > 0 ){
      if ( this.episodes![calculateWatchedEpisodes()].airDate != ""){
        try{
          var airDate = DateTime.parse("${this.episodes![calculateWatchedEpisodes()].airDate} 12:00:00.000");
          var diff = airDate.difference(DateTime.now());
          return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
        }
        catch(e){
          var airDate = DateTime.parse("2021-12-31 12:24:36.000");
          var diff = airDate.difference(DateTime.now());
          return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
        }

      }
    }
    return [Duration(days: 0), DateTime.now()];
  }
  bool nextEpisodeAired(){
    return nextEpisodeAirDate()[0].inDays < 0;
  }

  int calculateWatchedEpisodes(){
    int watchedEpisodes = 0;
    this.episodePerSeason!.forEach((key, int value) {
      if ( int.parse(key) < currentSeason.toInt()){
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
    this.episodePerSeason!.forEach((key, value) {
      totalEpisodes += value;
    });
    return totalEpisodes;
  }

  double calculateProgress() {
    int watchedEpisodes = calculateWatchedEpisodes();
    int totalEpisodes = calculateTotalEpisodes();
    double total = watchedEpisodes / totalEpisodes;
    return total > 1.0 ? 1.0 : total;
  }

  int? getWatchedTimes(){
    return this.watchedTimes;
  }

   incrementEpisodeWatch() {
     if ( currentSeason < totalSeasons!.toInt()){
       if(currentEpisode < episodePerSeason![currentSeason.toString()]!.toInt() ){
         currentEpisode++;
       }
       else{
         //do nothing
         currentSeason++;
         currentEpisode = 1;
       }
     }
     else{
       if(currentEpisode < episodePerSeason![currentSeason.toString()]!.toInt() ){
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

    var show = WatchedTVShow(
        name : json['name'],
        startDate : json['start_date'],
        runtime : json['runtime'] ??  0,
        rating : json['rating'] ?? 0.0,
        imageThumbnailPath : json['image_thumbnail_path'].replaceFirst('http', 'https'),
        totalSeasons : json['total_seasons'],
        episodePerSeason : json['episodesPerSeason'],
        currentSeason : json['currentSeason'],
        currentEpisode : json['currentEpisode'],
        firstWatchDate : json['startedWatching'],
        lastWatchDate : json['lastWatched'],
        favorite: json['favorite'] ?? false,
        watchedTimes : json['watchedTimes'] ?? 0

    );
    return show;
  }
  factory WatchedTVShow.fromFirestore(Map <String, dynamic> json, dynamic collId){
    return WatchedTVShow(
        id: collId,
        name : json['name'],
        startDate : json['start_date'],
        runtime : json['runtime'] ??  0,
        rating : json['rating'] ?? 0.0,
        imageThumbnailPath : json['image_thumbnail_path'].contains('https') ? json['image_thumbnail_path'] : json['image_thumbnail_path'].replaceFirst('http', 'https'),
        totalSeasons : json['total_seasons'],
        episodePerSeason : Map<String, int>.from(json['episodesPerSeason']),
        currentSeason : json['currentSeason'],
        currentEpisode : json['currentEpisode'],
        firstWatchDate : json['startedWatching'],
        lastWatchDate : json['lastWatched'],
        favorite: json['favorite'] ?? false,
        watchedTimes : json['watchedTimes'] ?? 0
    );
  }

  String newestEpisodeDifference() {
    String diff = episodes!.last.getDifference();
    return diff;
  }
}



