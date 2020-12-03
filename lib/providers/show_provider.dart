import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';

class ShowProvider extends ChangeNotifier{
  List<WatchedTVShow> _watchedShowList = [];
  List<Episode> _scheduledList = [];
  WatchedTVShow _currentShow;

  List<WatchedTVShow> get watchedShowList => _watchedShowList;
  List<Episode> get scheduledList => _scheduledList;
  WatchedTVShow get currentShow => _currentShow;

  var _watchedShowsStream = FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots();


   Stream<List<WatchedTVShow>> getWatchedShows(){
    GlobalVariables.watchedShowIdList.clear();
    _watchedShowList.clear();
    var x = _watchedShowsStream.map((snapshot) => snapshot.docs.map((doc){
      GlobalVariables.watchedShowIdList.add(int.parse(doc.id));
      WatchedTVShow show = new WatchedTVShow.fromFirestore(doc.data(), doc.id);
      _watchedShowList.add(show);
      return show;
    }).toList());
    print("GET - ${_watchedShowList.length}");
    notifyListeners();
    return x;
  }

  setCurrentShow(WatchedTVShow show){
     _currentShow = show;
     notifyListeners();
  }

  nextAirDate(){
    notifyListeners();
    return currentShow.episodes[currentShow.calculateWatchedEpisodes()].getDifference();
  }

  void setList(List<WatchedTVShow> watchedShowsList) {
     _watchedShowList = watchedShowsList;
     // notifyListeners();

  }

  void setScheduledList(List<Episode> notAiredList) {
     _scheduledList = notAiredList;
     // notifyListeners();
  }
}