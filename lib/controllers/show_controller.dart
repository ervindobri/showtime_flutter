import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/network/network.dart';

class ShowController {
  final FirestoreUtils firestoreService;
  ShowController({required this.firestoreService});

  ValueNotifier<List<WatchedTVShow>> watchedShows =
      ValueNotifier(<WatchedTVShow>[]);
  List<int> watchedShowIds = [];
  ValueNotifier<List<List<Episode>>> scheduledEpisodes =
      ValueNotifier(<List<Episode>>[]);
  ValueNotifier<List<Episode>> notAiredList = ValueNotifier(<Episode>[]);

  ValueNotifier<List<WatchedTVShow>> sortedList =
      ValueNotifier(<WatchedTVShow>[]);
  ValueNotifier<bool> isAscending = ValueNotifier(true);
  ValueNotifier<bool> searchInProgress = ValueNotifier(false);

  // ignore: invalid_use_of_protected_member
  List<Episode> get notAired => notAiredList.value;
  // ignore: invalid_use_of_protected_member
  List<List<Episode>> get scheduled => scheduledEpisodes.value;
  // ignore: invalid_use_of_protected_member
  List<WatchedTVShow> get watched => watchedShows.value;

  ValueNotifier<String> searchTerm = ValueNotifier('');
  ValueNotifier<bool> loaded = ValueNotifier(false);

  Future<void> initialize() async {
    watchedShowIds.clear();

    // Fetch watched shows from firestore
    await fetchWatchedShows();

    // Fetch scheduled episodes from tvmaze
    await fetchScheduledEpisodes();

    // Setup Episodes that are airing soon
    getNotAired();
    loaded.value = true;
  }

  Future<void> fetchWatchedShows() async {
    // watchedShows.dispose();
    List<WatchedTVShow> result = [];
    await firestoreService.watchedShows
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (!watchedShowIds.contains(int.tryParse(doc.id))) {
          // somehow duplicates get in FFS
          watchedShowIds.add(int.parse(doc.id));
        } else {
          final show = WatchedTVShow.fromFirestore(
              (doc.data() as Map<String, dynamic>), doc.id);

          result.add(show);
        }
      }
      return;
    });
    watchedShows.value = result;
    sortedList.value = watchedShows.value;
  }

  Future<void> fetchScheduledEpisodes() async {
    await firestoreService.getEpisodeList(watchedShowIds).then((value) {
      scheduledEpisodes.value = value;
    });
  }

  void getNotAired() {
    List<Episode> episodes = [];
    for (int index = 0; index < scheduled.length; index++) {
      int notAired = scheduled[index].length - 1;
      for (int i = 0; i < scheduled[index].length; i++) {
        if (!scheduled[index][i].aired()) {
          notAired = i;
          break;
        }
      }
      episodes.add(scheduled[index][notAired]);
    }
    episodes.sort((a, b) => a.airDate!.compareTo(b.airDate!));
    episodes = episodes.toSet().toList();
    notAiredList.value = episodes;
  }

  getShowData(WatchedTVShow show) async {
    try {
      List<dynamic> list = await Network().getDetailUpdates(showID: show.id);
      var snapshots = firestoreService.watchedShows.doc(show.id).snapshots();
      snapshots.first.then((value) {
        show.currentSeason =
            (value.data() as Map<String, dynamic>)['currentSeason'];
        show.totalSeasons = list[0];
        show.episodePerSeason = Map<String, int>.from(list[1]);
        show.currentEpisode =
            (value.data() as Map<String, dynamic>)['currentEpisode'];
        // return show;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getCriteria(WatchedTVShow a, String criteria) {
    // print(a);
    Map<String, dynamic> criteriaMap = {
      "Title": a.name,
      "Year": a.startDateString,
      "Runtime": a.runtime,
      "Progress": a.calculatedProgress,
      "Rating": a.rating
    };
    return criteriaMap[criteria];
  }

  sort(String x) async {
    searchInProgress.value = true;
    isAscending.value = !isAscending.value;
    if (isAscending.value) {
      sortedList.value
          .sort((a, b) => getCriteria(a, x).compareTo(getCriteria(b, x)));
    } else {
      sortedList.value
          .sort((a, b) => getCriteria(b, x).compareTo(getCriteria(a, x)));
    }
    await Future.delayed(const Duration(milliseconds: 500), () {});
    searchInProgress.value = false;
  }

  filter(String value) async {
    searchInProgress.value = true;
    sortedList.value = watched
        .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    await Future.delayed(const Duration(milliseconds: 500), () {});
    searchInProgress.value = false;
  }
}
