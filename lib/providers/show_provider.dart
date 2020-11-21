import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/network/firebase_utils.dart';

class ShowProvider{
  var _watchedShowsStream = FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots();

  Stream<QuerySnapshot> getWatchedShows(){
    return _watchedShowsStream;
  }
}