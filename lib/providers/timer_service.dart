
import 'dart:async';

import 'package:eWoke/models/watched.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TimerService extends ChangeNotifier {
  Timer _timer;
  String _countDown;
  String get countDown => _countDown;

  WatchedTVShow _show;
  WatchedTVShow get show => _show;

  TimerService(){
    _countDown = "00:00:00";
  }

  void init(WatchedTVShow show){
    _show = show;
    startTimer();
  }

  // TimerService() {
    // startTimer();
  // }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
            (Timer timer) {
          _countDown = _show.episodes[show.calculateWatchedEpisodes()].getDifference();
          notifyListeners();
        }
    );
  }

}
