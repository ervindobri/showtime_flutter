import 'dart:convert';

import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class APIService {
  // API key
  static const _api_key = "b49536d305mshba5244f6247a159p1a26e3jsn07eed6329ea5";
  // Base API url
  static const String _baseUrl = "imdb8.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "imdb8.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };


  // Base API request to get response
  Future<dynamic> get({
    required String endpoint,
    required Map<String, String> query,
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
  Future<TVShow?> getShowResults({required String imdbLink}) async{
    try{
      var searchURL = GlobalVariables.IMDBSHOW_URL + imdbLink;
      // print(searchURL);
      final response = await http.get(Uri.parse(searchURL));

      if (response.statusCode == 200) {
        return TVShow.fromJson(json.decode(response.body));
      }
      else {
        print("Couldn't get  IMDB show data from TVMAZE.");
      }
    }catch(e){
      print(e);
    }
    return null;
  }
}
