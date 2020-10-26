import 'package:eWoke/components/badge.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/models/episode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const FONTFAMILY = 'Raleway';

const greenColor = const Color(0xFF00C797);
const lightGreenColor = const Color(0xFF80E6CE);
const blueColor = const Color(0xFF8196FF);
const greyTextColor = const Color(0xFF565656);

const fireColor = const Color(0xFFF3403F);
const lightFireColor = const Color(0xFFFF8EB4);
const pinkColor = const Color(0xffff3847);
const lightPinkColor = const Color(0xFFFFAEB4);

const goldColor = const Color(0xffffd230);
const lightGoldColor = const Color(0xffffe27a);

const orangeColor = const Color(0xFFff2819);
const bgColor = const Color(0xFFF9F9F9);

const EPISODES_URL = "https://api.tvmaze.com/shows/";

const SEARCH_URL = "http://api.tvmaze.com/search/shows?q=";

const FULL_SCHEDULE_URL = "https://api.tvmaze.com/schedule/full";

//Concat these two to get episodes by date
const SHOW_URL = "https://api.tvmaze.com/shows/";
const SCHEDULE_URL = "/episodesbydate?date=";

const IMDBSHOW_URL = "http://api.tvmaze.com/lookup/shows?imdb=";


const PLACEHOLDER_IMAGE = "https://wolper.com.au/wp-content/uploads/2017/10/image-placeholder.jpg";

List<WatchedTVShow> watchedShowList = new List<WatchedTVShow>();
List<TVShowDetails> showDetailList = new List<TVShowDetails>();
List<WatchedTVShow> favorites = new List<WatchedTVShow>();
List<List<Episode>> scheduledEpisodes = [];
List<TVShow> popularShows = [];
List<WatchedTVShow> list = new List<WatchedTVShow>();

List<WatchedTVShow> allWatchedShows = new List<WatchedTVShow>();

const Map<String, Badge> allBadges = {
  "fresh" : Badge(icon: FontAwesomeIcons.fire, colors:[fireColor, Colors.orange]),
  "paused" : Badge(icon: FontAwesomeIcons.pause, colors:[Colors.purple, Colors.indigo]),
  "justStarted" : Badge(icon: FontAwesomeIcons.airFreshener, colors:[goldColor, lightGoldColor]),
  "watching" : Badge(icon: FontAwesomeIcons.hourglassHalf, colors:[greyTextColor, Colors.white54]),
  "finished" : Badge(icon: FontAwesomeIcons.checkDouble, colors:[greenColor, Colors.greenAccent]),
  "hasMoreEpisodes" : Badge(icon: FontAwesomeIcons.pizzaSlice, colors:[Colors.orangeAccent, Colors.orange]),
  "waiting" : Badge(icon: FontAwesomeIcons.stopwatch20, colors:[Colors.lightBlue, blueColor]),
  "favorite" : Badge(icon: FontAwesomeIcons.solidHeart, colors:[pinkColor,lightPinkColor]),
};



const List DISCOVER_DATA = [ ["Overall Progress", 0xFF595959, 0xFFB1B1B1, FontAwesomeIcons.spinner], ["Most popular shows",0xFFFF006F, 0xFFFFDBE2, FontAwesomeIcons.fire], ["Watchlist", 0xFF59b4ff, 0xffbfe2ff, FontAwesomeIcons.binoculars] ,["Favorites", 0xFFFFAEB4, 0xfffff5e2,FontAwesomeIcons.solidHeart]];
List<String> searchHistory = [];
const List SORT_CATEGORIES = [ "Title", "Year", "Runtime" , "Progress", "Rating"];

//region OLD_DATA
const List SHOWS_DATA = [
  [
    {
      "showID": "5995",
      "name": "The Office",
      "runtime": 30,
      "start_date": "2005-03-24",
      "image_thumbnail_path": "https://m.media-amazon.com/images/M/MV5BMDNkOTE4NDQtMTNmYi00MWE0LWE4ZTktYTc0NzhhNWIzNzJiXkEyXkFqcGdeQXVyMzQ2MDI5NjU@._V1_SY999_CR0,0,665,999_AL_.jpg",
      "total_seasons": 9,
      "episodesPerSeason": {
        "1": 23,
        "2": 23,
        "3": 23,
        "4": 23,
        "5": 23,
        "6": 23,
        "7": 23,
        "8": 23,
        "9": 23
      },
      "currentSeason": 9,
      "currentEpisode": 5,
      "startedWatching": "2020-01-01",
      "lastWatched": "2020-08-07"
    },
    {
      "showID": "17658",
      "name": "Breaking Bad",
      "start_date": "2008-01-20",
      "runtime" : 60,
      "image_thumbnail_path": "m.media-amazon.com/images/M/MV5BMjhiMzgxZTctNDc1Ni00OTIxLTlhMTYtZTA3ZWFkODRkNmE2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SY1000_CR0,0,718,1000_AL_.jpg",
      "total_seasons": 5,
      "episodesPerSeason": {
        "1": 7,
        "2": 13,
        "3": 13,
        "4": 13,
        "5": 16
      },
      "currentSeason": 5,
      "currentEpisode": 16,
      "startedWatching": "2016-04-05",
      "lastWatched": "2016-08-08"
    },
    {
      "showID": "59970",
      "name": "The Punisher",
      "start_date": "2017-11-17",
      "runtime" : 60,
      "image_thumbnail_path": "https://m.media-amazon.com/images/M/MV5BMTExODIwOTUxNzFeQTJeQWpwZ15BbWU4MDE5MDA0MTcz._V1_SY1000_CR0,0,674,1000_AL_.jpg",
      "total_seasons": 2,
      "episodesPerSeason": {
        "1": 13,
        "2": 13
      },
      "currentSeason": 1,
      "currentEpisode": 9,
      "startedWatching": "2020-01-01",
      "lastWatched": "2020-08-05"
    }
  ]
];
// endregion