import 'package:show_time/models/watched.dart';
import 'package:get/get.dart';
import 'dart:async';


class TimerController extends GetxController{
  late Timer _timer;
  late String _countDown;
  String get countDown => _countDown;

  late WatchedTVShow _show;
  WatchedTVShow get show => _show;

  @override
  void onInit() {
    super.onInit();
    _countDown = "00:00:00";
    // init(show);
  }

  void init(WatchedTVShow show){
    _show = show;
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
            (Timer timer) {
          _countDown = _show.newestEpisodeDifference();
        }
    );
  }
}