import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:show_time/models/episode.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:get/get.dart';
import 'package:show_time/network/network.dart';

class ShowController extends GetxController{
  var watchedShows = <WatchedTVShow>[].obs;
  List<int> watchedShowIds = [];
  var scheduledEpisodes = <List<Episode>>[].obs;
  var notAiredList = <Episode>[].obs;

  List<WatchedTVShow> sortedList = [];

  RxBool isAscending = true.obs;


  // ignore: invalid_use_of_protected_member
  List<Episode> get notAired  => notAiredList.value;
  // ignore: invalid_use_of_protected_member
  List<List<Episode>> get scheduled  => scheduledEpisodes.value;
  // ignore: invalid_use_of_protected_member
  List<WatchedTVShow> get watched => watchedShows.value;


  RxString searchTerm = ''.obs;
  RxBool loaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize(){
    watchedShowIds.clear();
    fetchWatchedShows();
    fetchScheduledEpisodes();
    sortedList = watched.where((e) => e.name!.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    loaded.value = true;
  }

  void fetchWatchedShows() async {
      watchedShows.clear();
      List<WatchedTVShow> result = [];
      await FirestoreUtils().watchedShows
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          if ( !watchedShowIds.contains(doc.id)){ //somehow duplicates get in FFS
            watchedShowIds.add(int.parse(doc.id));
          }
          WatchedTVShow show = new WatchedTVShow.fromFirestore(doc.data()!, doc.id);
          result.add(show);
        })});
      watchedShows.assignAll(result);

  }


  getCriteria(WatchedTVShow a, String criteria) {
    // print(a);
    Map<String, dynamic> criteriaMap = {
      "Title": a.name,
      "Year": a.startDate,
      "Runtime": a.runtime,
      "Progress": a.calculateProgress(),
      "Rating" : a.rating ?? 0.0
    };
    return criteriaMap[criteria];
  }

  //TODO: scheduled episodes

  @override
  void onClose() {
    watchedShows.close();
    watchedShowIds.clear();
    scheduledEpisodes.close();
    notAiredList.close();
    super.onClose();
  }

  void fetchScheduledEpisodes() async {
    print("Fetching scheduled episodes! ${watchedShowIds.length}");
    await FirestoreUtils().getEpisodeList(watchedShowIds).then((value) {
      scheduledEpisodes.assignAll(value);
    });
    getNotAired();

  }

  void getNotAired() {
    List<Episode> episodes = [];
      for(int index=0 ; index < scheduled.length; index++){
        int notAired = scheduled[index].length - 1;
          for(int i=0; i< scheduled[index].length ; i++){
              if ( !scheduled[index][i].aired()){
                  notAired = i;
                  break;
              }
          }
        episodes.add(scheduled[index][notAired]);

      }
    episodes.sort( (a,b) => a.airDate!.compareTo(b.airDate!));
    episodes = episodes.toSet().toList();
    notAiredList.assignAll(episodes);
  }
  getShowData(WatchedTVShow show) async {
    try{
      List<dynamic> list = await new Network().getDetailUpdates(showID: show.id);
      var snapshots = FirestoreUtils().watchedShows.doc(show.id).snapshots();
      snapshots.first.then((value) {
        show.currentSeason = value.data()!['currentSeason'];
        show.totalSeasons = list[0];
        show.episodePerSeason = Map<String, int>.from(list[1]);
        show.currentEpisode = value.data()!['currentEpisode'];
        // return show;
      });
    }
    catch(e ){
      print(e);
      rethrow;
    }
  }

  sort(String x){
    isAscending.value = !isAscending.value!;
    if (isAscending.value!){
      sortedList.sort((a, b) => getCriteria(a, x).compareTo(getCriteria(b, x)));
    }
    else{
      sortedList.sort((a, b) => getCriteria(b, x).compareTo(getCriteria(a, x)));
    }
  }
  filter(String value) {
    sortedList = watched.where((e) => e.name!.toLowerCase().contains(value.toLowerCase())).toList();
  }
}