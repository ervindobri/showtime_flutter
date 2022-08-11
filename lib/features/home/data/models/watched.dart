// ignore_for_file: prefer_initializing_formals

import 'package:equatable/equatable.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/home/data/models/countdown.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/models/tvshow_details.dart';

part 'watched_ext.dart';

class WatchedTVShow extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final String imageThumbnailPath;
  final int runtime;
  final num rating;
  final List<String> genres;
  final String? firstWatchDate;
  final Map<String, dynamic>? criteriaMap;

  WatchedTVShow(
      {required this.id,
      required this.name,
      required this.startDate,
      this.imageThumbnailPath = "",
      required this.runtime,
      this.rating = 0.0,
      this.genres = const <String>[],
      episodes = const <Episode>[],
      this.totalSeasons = 0,
      this.episodePerSeason = const {},
      currentSeason = 0,
      currentEpisode = 0,
      this.firstWatchDate,
      lastWatchDate,
      this.criteriaMap,
      this.favorite,
      this.watchedTimes = 0})
      : lastWatchDate = lastWatchDate,
        episodes = episodes,
        currentSeason = currentSeason,
        currentEpisode = currentEpisode;

  //These fields will change dynamically
  int totalSeasons;
  Map<String, int> episodePerSeason;
  bool? favorite;
  String? lastWatchDate;
  int currentSeason = 0;
  int currentEpisode = 0;
  List<Episode> episodes;
  int watchedTimes;

  get startDateString => startDate.toString();

  bool hasMoreEpisodes() {
    bool flag = false;
    for (var show in GlobalVariables.scheduledEpisodes) {
      // print("${show[0].embedded['show']['id']} == ${this.id}");
      if (show[0].embedded!['show']['id'].toString() == id) {
        flag = true;
      }
    }
    return flag;
  }

  int stopWatch() {
    var firstWatched = DateTime.parse("$firstWatchDate");
    var lastWatched = DateTime.parse("$lastWatchDate");
    int diffDays = lastWatched.difference(firstWatched).inDays;
    return diffDays.abs();
  }

  int diffDays() {
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    return diffDays;
  }

  nextEpisodeAirDate() {
    if (calculateWatchedEpisodes() == 0) {
      if (episodes[0].airDate != "") {
        var airDate = DateTime.parse("${episodes[0].airDate} 12:00:00.000");
        var diff = airDate.difference(DateTime.now());
        return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
      }
    } else if (calculateWatchedEpisodes() > 0) {
      if (episodes[calculateWatchedEpisodes()].airDate != "") {
        try {
          var airDate = DateTime.parse(
              "${episodes[calculateWatchedEpisodes()].airDate} 12:00:00.000");
          var diff = airDate.difference(DateTime.now());
          return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
        } catch (e) {
          var airDate = DateTime.parse("2021-12-31 12:24:36.000");
          var diff = airDate.difference(DateTime.now());
          return [diff, "${airDate.year}/${airDate.month}/${airDate.day}"];
        }
      }
    }
    return [const Duration(days: 0), DateTime.now()];
  }

  bool get nextEpisodeAired => nextEpisodeAirDate()[0].inDays < 0;

  int get totalEpisodesThisSeason =>
      episodePerSeason[currentSeason.toString()] ?? 0;

  int calculateWatchedEpisodes() {
    int watchedEpisodes = 0;
    episodePerSeason.forEach((String key, int value) {
      if (int.parse(key) < currentSeason.toInt()) {
        watchedEpisodes += value;
      } else if (currentSeason == int.parse(key)) {
        watchedEpisodes += currentEpisode;
      }
    });
    return watchedEpisodes;
  }

  int get calculateTotalEpisodes {
    int totalEpisodes = 0;
    episodePerSeason.forEach((key, value) {
      totalEpisodes += value;
    });
    return totalEpisodes;
  }

  double get calculatedProgress {
    int watchedEpisodes = calculateWatchedEpisodes();
    int totalEpisodes = calculateTotalEpisodes;
    double total = watchedEpisodes / totalEpisodes;
    return total > 1.0 ? 1.0 : total;
  }

  int? getWatchedTimes() {
    return watchedTimes;
  }

  incrementEpisodeWatch() {
    if (currentSeason < totalSeasons.toInt()) {
      if (currentEpisode <
          episodePerSeason[currentSeason.toString()]!.toInt()) {
        currentEpisode++;
      } else {
        //do nothing
        currentSeason++;
        currentEpisode = 1;
      }
    } else {
      if (currentEpisode <
          episodePerSeason[currentSeason.toString()]!.toInt()) {
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
    lastWatchDate = DateTime.now().year.toString() +
        "-" +
        mZero +
        DateTime.now().month.toString() +
        "-" +
        dZero +
        DateTime.now().day.toString();
  }

  factory WatchedTVShow.fromDetails(TVShowDetails show) {
    return WatchedTVShow(
        id: show.id,
        name: show.name,
        startDate: show.startDate,
        runtime: show.runtime,
        rating: show.rating,
        imageThumbnailPath: show.imageThumbnailPath ?? "",
        totalSeasons: show.totalSeasons ?? 0,
        episodePerSeason: show.episodePerSeason ?? {},
        currentSeason: 1,
        currentEpisode: 0,
        favorite: false);
  }

  factory WatchedTVShow.fromJson(Map<String, dynamic> json) {
    return WatchedTVShow(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        startDate: json['start_date'] ?? "",
        runtime: json['runtime'] ?? 0,
        rating: json['rating'] ?? 0.0,
        imageThumbnailPath:
            json['image_thumbnail_path'].replaceFirst('http', 'https'),
        totalSeasons: json['total_seasons'],
        episodePerSeason: json['episodesPerSeason'],
        currentSeason: json['currentSeason'],
        currentEpisode: json['currentEpisode'],
        firstWatchDate: json['startedWatching'],
        lastWatchDate: json['lastWatched'],
        favorite: json['favorite'] ?? false,
        watchedTimes: json['watchedTimes'] ?? 0);
  }
  factory WatchedTVShow.fromFirestore(
      Map<String, dynamic> json, dynamic collId) {
    return WatchedTVShow(
        id: collId,
        name: json['name'] ?? "",
        startDate: DateTime.parse(json['start_date'] ?? "0000-00-00"),
        runtime: json['runtime'] ?? 0,
        rating: json['rating'],
        imageThumbnailPath: json['image_thumbnail_path'].contains('https')
            ? json['image_thumbnail_path']
            : json['image_thumbnail_path'].replaceFirst('http', 'https'),
        totalSeasons: json['total_seasons'],
        episodePerSeason: Map<String, int>.from(json['episodesPerSeason']),
        currentSeason: json['currentSeason'] ?? "",
        currentEpisode: json['currentEpisode'] ?? "",
        firstWatchDate: json['startedWatching'] ?? "",
        lastWatchDate: json['lastWatched'] ?? "",
        favorite: json['favorite'] ?? false,
        watchedTimes: json['watchedTimes'] ?? 0);
  }

  String newestEpisodeDifference() {
    String diff = episodes.last.getDifference().displayLetters;
    return diff;
  }

  @override
  List<Object?> get props => [id, name];
}
