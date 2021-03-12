import 'dart:convert';

import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/models/episode.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:http/http.dart';

class Network{

  Future<AllTVShowList> getShowResults({required String showName}) async{
    var searchURL = GlobalVariables.SEARCH_URL + showName;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return AllTVShowList.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Error getting show data!");
    }
  }

  Future<TVShowDetails> getDetailResults({required TVShow show}) async{
    var searchURL = GlobalVariables.EPISODES_URL + show.id + '/episodes';
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return TVShowDetails.fromJson(show, json.decode(response.body));
    }
    else {
      throw Exception("Error getting show data!");
    }
  }

  Future<TVShow> getShowInfo({required String showID}) async{
    var searchURL = GlobalVariables.SHOW_URL + showID;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return TVShow.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Error getting show data!");
    }
  }

  Future<List<dynamic>> getEpisodes({required String showID}) async{
    var searchURL = GlobalVariables.EPISODES_URL + showID + '/episodes';
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      // print(response.body);
      return json.decode(response.body).map((i) => Episode.fromJson(i)).toList();
    }
    else {
      throw Exception("Error getting episode data!");
    }
  }
  Future<List<dynamic>> getDetailUpdates({required String showID}) async{
    // print(showID);
    var searchURL = GlobalVariables.EPISODES_URL+ showID + "/episodes";
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return getUpdates(json.decode(response.body));
    }
    else {
      throw Exception("Error getting show data!");
    }
  }
  List<dynamic> getUpdates(List <dynamic> json){
    List<dynamic> result = [];
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
    result.add(totalSeasons);
    result.add(episodePerSeason);
    return result;
  }

  Future<EpisodeList> getScheduledEpisodes() async{
    var searchURL = GlobalVariables.FULL_SCHEDULE_URL;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return EpisodeList.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Error getting show data!");
    }
  }


}

