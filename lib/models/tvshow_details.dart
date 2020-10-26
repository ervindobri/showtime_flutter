import 'package:eWoke/models/tvshow.dart';

import 'episode.dart';

class AllTVShowDetailsList{
  final String total;
  final int page;
  final int pages;
  final List<dynamic> showList;


  AllTVShowDetailsList({this.total,this.page, this.pages, this.showList});

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
  String description;
  String ratingCount;
  List<dynamic> pictures;
  String imagePath;
  List<dynamic> episodes;
  int totalSeasons;
  Map<String, dynamic> episodePerSeason;

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

  factory TVShowDetails.fromJson(TVShow show, List <dynamic> json){

    List<dynamic> episodes;
    episodes = json.map((i) => Episode.fromJson(i)).toList();
    Map<String, dynamic> episodePerSeason = new Map<String, dynamic>();
    int totalSeasons = json.length>0 ? json[json.length - 1]['season'] : 0;
    if(totalSeasons > 0){
      for(int i = 1 ; i<=totalSeasons; ++i){
        int max = 1;
        json.forEach((element){
          if ( element['season'] == i){
            if ( max < element['number']){
              max = element['number'];
            }
            else{
            }
          }
        });
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
    if ( this.id != null && this.name != null && this.episodePerSeason != null){
      return true;
    }
    return false;
  }
}


