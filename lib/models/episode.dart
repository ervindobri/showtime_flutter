import 'package:eWoke/constants/custom_variables.dart';

class EpisodeList{
  final List<Episode> episodes;

  EpisodeList({this.episodes});

  factory EpisodeList.fromJson(List<dynamic> json){
    List episodes;
    episodes = json.map((i) => Episode.fromJson(i)).toList();
    return EpisodeList(
      episodes : episodes,
    );
  }
}



class Episode{
  int id;
  int season;
  int episode;
  String name;
  String airDate;
  String airTime;
  int runtime;
  String image;
  String summary;

  Map<String, dynamic> embedded;

  Episode({this.id, this.season, this.episode, this.name, this.airDate,
      this.airTime, this.runtime, this.image, this.summary, this.embedded});

  factory Episode.fromJson(Map <String, dynamic> json){
    // print("episode");
    return Episode(
      id : json['id'] ?? 0,
      season : json['season'] ?? 0 ,
      episode : json['number'] ?? 0 ,
      name : json['name'] ?? "",
      airDate : json['airdate'] == "" ? (DateTime.now().year+1).toString() + "-" + (DateTime.now().month).toString() + (DateTime.now().day).toString() : json['airdate'],
      airTime : json['airtime'] == "" ? "12:00" : json['airtime'],
      runtime : json['runtime'] ?? 0,
      image : json['image'] != null ? json['image']['medium'] : PLACEHOLDER_IMAGE, //MEDIUM IMAGE
      summary : json['summary'] ?? "",
      embedded : json['_embedded'] ?? null
    );
  }

  String getDifference() {
    if ( this.airDate != null ){
      var airDate = DateTime.parse("${this.airDate} ${this.airTime}:00.000");
      // print(airDate);
      var diff = airDate.difference(DateTime.now());

      return "${diff.inDays.abs()}:${diff.inHours.remainder(24).abs()}:${diff.inMinutes.remainder(60).abs()}:${(diff.inSeconds.remainder(60).abs())}";
    }

  }

  int getDiffDays() {
    var airDate = DateTime.parse("${this.airDate} ${this.airTime}:00.000");
    int diffDays = DateTime.now().difference(airDate).inDays;
    // print(diffDays);
    return diffDays;
  }

  
  String getAirDateLabel() {
    int diffDays = getDiffDays();
    if (diffDays > 0) {
      return "${diffDays.abs()} day(s) ago";
    }
    else if (diffDays == 0) {
      return "Today";
    }
    else {
      return "In ${diffDays.abs()} day(s)";
    }
  }
}