import 'dart:convert';

import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:http/http.dart';

class Network {
  Future<AllTVShowList> getShowResults({required String showName}) async {
    var searchURL = GlobalVariables.searchUrl + showName;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return AllTVShowList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }

  Future<TVShowDetails> getDetailResults({required TVShow show}) async {
    var searchURL = GlobalVariables.episodesUrl + show.id + '/episodes';
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return TVShowDetails.fromJson(show, json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }

  Future<TVShow> getShowInfo({required String showID}) async {
    var searchURL = GlobalVariables.showUrl + showID;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return TVShow.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }

  Future<List<Episode>> getEpisodes({required String showID}) async {
    var searchURL = GlobalVariables.episodesUrl + showID + '/episodes';
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      List<Episode> list = json
          .decode(response.body)
          .map<Episode>((i) => Episode.fromJson(i))
          .toList();
      return list;
    } else {
      throw Exception("Error getting episode data!");
    }
  }

  Future<List<dynamic>> getDetailUpdates({required String showID}) async {
    // print(showID);
    var searchURL = GlobalVariables.episodesUrl + showID + "/episodes";
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return getUpdates(json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }

  List<dynamic> getUpdates(List<dynamic> json) {
    List<dynamic> result = [];
    Map<String, dynamic> episodePerSeason = <String, dynamic>{};
    int totalSeasons = json.isNotEmpty ? json[json.length - 1]['season'] : 0;
    if (totalSeasons > 0) {
      for (int i = 1; i <= totalSeasons; ++i) {
        int max = 1;
        for (var element in json) {
          if (element['season'] == i) {
            if (max < element['number']) {
              max = element['number'];
            } else {}
          }
        }
        episodePerSeason.putIfAbsent(i.toString(), () => max);
      }
    }
    result.add(totalSeasons);
    result.add(episodePerSeason);
    return result;
  }

  Future<EpisodeList> getScheduledEpisodes() async {
    var searchURL = GlobalVariables.fullScheduleUrl;
    final response = await get(Uri.parse(searchURL));

    if (response.statusCode == 200) {
      return EpisodeList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting show data!");
    }
  }
}
