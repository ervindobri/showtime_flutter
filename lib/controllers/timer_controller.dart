import 'package:flutter/foundation.dart';
import 'package:show_time/features/home/data/models/watched.dart';

import 'dart:async';

class TimerController {
  late Timer _timer;
  ValueNotifier<String> countDown = ValueNotifier('');

  late WatchedTVShow _show;
  WatchedTVShow get show => _show;

  // @override
  // void onInit() {
  //   super.onInit();
  //   countDown = "00:00:00".obs;
  //   // init(show);
  // }

  void init(WatchedTVShow show) {
    _show = show;
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      countDown.value = _show.newestEpisodeDifference();
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
