import 'package:eWoke/models/episode.dart';
import 'package:flutter/widgets.dart';

class EpisodeProvider with ChangeNotifier{
  Episode _episode;
  Episode get episode => _episode;


  // getDifference(){
  //   widget.show.episodes[widget.show.calculateWatchedEpisodes()].getDifference()
  // }
}