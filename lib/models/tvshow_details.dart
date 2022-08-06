import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:html/parser.dart';

import '../features/home/data/models/episode.dart';

class AllTVShowDetailsList{
  final String total;
  final int page;
  final int? pages;
  final List<dynamic> showList;


  AllTVShowDetailsList({required this.total,required this.page, this.pages, required this.showList});

  factory AllTVShowDetailsList.fromJson(Map <String, dynamic> json){
    List shows;
    shows = json['tv_shows'].map((i) => TVShow.fromJson(i)).toList();
    return AllTVShowDetailsList(
      total : json['total'],
      page : json['page'],
      pages : json['pages'],
      showList : shows,
    );
  }
}


class TVShowDetails extends TVShow{
  String? description;
  String? ratingCount;
  List<dynamic>? pictures;
  String? imagePath;
  List<Episode>? episodes;
  int? totalSeasons;
  Map<String, int>? episodePerSeason;

  TVShowDetails(
      {     id,
        name,
        startDate,
        genres,
        language,
        status,
        rating,
        imageThumbnailPath,
        summary,
        runtime,
        this.episodes,
        this.totalSeasons,
        this.episodePerSeason
      }):super(
    id: id,
    name : name,
    startDate : startDate,
    genres: genres,
    language : language,
    rating: rating,
    status : status,
    imageThumbnailPath : imageThumbnailPath,
    summary: summary,
    runtime : runtime
  );


  @override
  String toString() {
    return 'TVShowDetails{description: $description, ratingCount: $ratingCount, pictures: $pictures, imagePath: $imagePath, episodes: $episodes, totalSeasons: $totalSeasons, episodePerSeason: $episodePerSeason}';
  }

  String? countryCode(){
    // print(countryCodes[0]["name"]);
    print(language);
    if ( language!.isNotEmpty){
        var x  = GlobalVariables.countryCodes.firstWhere((element) => element["name"] == language);
        return x["code"].toString().toUpperCase();
    }
    return null;
  }

  String parseHtmlString() {
    try {
      var document = parse(summary);
      String parsedString = parse(document.body!.text).documentElement!.text;
      return parsedString;
    } catch (e) {
      return "No description";
    }
  }

  factory TVShowDetails.fromJson(TVShow show, List <dynamic> json){

    List<Episode> episodes;
    episodes = json.map((i) => Episode.fromJson(i)).toList();
    Map<String, int> episodePerSeason = <String, int>{};
    int totalSeasons = json.isNotEmpty ? json[json.length - 1]['season'] : 0;
    if(totalSeasons > 0){
      for(int i = 1 ; i<=totalSeasons; ++i){
        int max = 1;
        for (var element in json) {
          if ( element['season'] == i){
            if ( max < element['number']){
              max = element['number'];
            }
            else{
            }
          }
        }
        episodePerSeason.putIfAbsent(i.toString(),() => max);
      }
    }
    return TVShowDetails(
        id : show.id,
        name : show.name,
        startDate : show.startDate,
        language : show.language,
        status : show.status,
        summary: show.summary,
        imageThumbnailPath : show.imageThumbnailPath,
        runtime: show.runtime,
        rating : show.rating,
        genres : show.genres,
        episodes: episodes,
        totalSeasons: totalSeasons,
        episodePerSeason: episodePerSeason
    );

  }

  bool isSafe() {
    if ( name != null && episodePerSeason != null){
      return true;
    }
    return false;
  }
}


