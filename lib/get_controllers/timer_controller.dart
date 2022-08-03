import 'package:show_time/features/home/data/models/watched.dart';
import 'package:get/get.dart';
import 'dart:async';


class TimerController extends GetxController{
  late Timer _timer;
  RxString countDown = ''.obs;

  late WatchedTVShow _show;
  WatchedTVShow get show => _show;

  @override
  void onInit() {
    super.onInit();
    countDown = "00:00:00".obs;
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
              countDown.value = _show.newestEpisodeDifference();
        }
    );
  }
  void cancelTimer(){
    _timer.cancel();
  }
}