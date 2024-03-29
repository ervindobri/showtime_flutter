import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/home/data/models/countdown.dart';

class EpisodeList {
  final List<Episode> episodes;

  EpisodeList({required this.episodes});

  factory EpisodeList.fromJson(List<dynamic> json) {
    List<Episode> episodes = <Episode>[];
    episodes = json.map((i) => Episode.fromJson(i)).cast<Episode>().toList();
    return EpisodeList(
      episodes: episodes,
    );
  }
}

class Episode {
  int id;
  int? season;
  int? episode;
  String? name;
  String? airDate;
  String? airTime;
  int? runtime;
  String? image;
  String? summary;

  Map<String, dynamic>? embedded;

  DateTime get airDatetime {
    return DateTime.parse("$airDate $airTime");
  }

  Episode(
      {required this.id,
      this.season,
      this.episode,
      this.name,
      this.airDate,
      this.airTime,
      this.runtime,
      this.image,
      this.summary,
      this.embedded});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        id: json['id'] ?? 0,
        season: json['season'] ?? 0,
        episode: json['number'] ?? 0,
        name: json['name'] ?? "",
        airDate: json['airdate'] == ""
            ? (DateTime.now().year + 69).toString() + "-12-12"
            : json['airdate'],
        airTime: json['airtime'] == "" ? "12:00" : json['airtime'],
        runtime: json['runtime'] ?? 0,
        image: json['image'] != null
            ? json['image']['medium']
            : GlobalVariables.placeholderImageUrl, //MEDIUM IMAGE
        summary: json['summary'] ?? "",
        embedded: json['_embedded']);
  }

  @override
  String toString() {
    return 'Episode{id: $id, season: $season, episode: $episode, name: $name, airDate: $airDate, airTime: $airTime, runtime: $runtime, image: $image, summary: $summary, embedded: $embedded}';
  }

  bool aired() {
    try {
      if (airDate != null) {
        var airDate = DateTime.parse("${this.airDate} $airTime:00.000");
        // print(airDate);
        var diff = airDate.difference(DateTime.now());
        // print(diff);
        return diff < Duration.zero;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Countdown getDifference() {
    if (airDate != null) {
      var airDate = DateTime.parse("${this.airDate} $airTime:00.000");
      var diff = airDate.difference(DateTime.now());

      return Countdown(
        diff.inDays.abs(),
        diff.inHours.remainder(24).abs(),
        diff.inMinutes.remainder(60).abs(),
        diff.inSeconds.remainder(60).abs(),
      );
    }
    return const Countdown.zero();
  }

  int getDiffDays() {
    var airDate = DateTime.parse("${this.airDate} $airTime:00.000");
    int diffDays = DateTime.now().difference(airDate).inDays;
    // print(diffDays);
    return diffDays;
  }

  String getAirDateLabel() {
    int diffDays = getDiffDays();
    if (diffDays > 0) {
      return "$diffDays day(s) ago";
    } else if (diffDays == 0) {
      return "Today";
    } else {
      return "In ${diffDays.abs()} day(s)";
    }
  }
}
