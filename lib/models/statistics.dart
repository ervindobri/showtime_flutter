import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Statistics{

  Map <int, int> monthsAsX = {
    DateTime.now().month -2 : 2,
    DateTime.now().month -1 : 7,
    DateTime.now().month : 12
  };

  Map <int, int> yearAsX = {
    DateTime.now().year -10 : 0, //13
    DateTime.now().year -9 : 0, //13
    DateTime.now().year -8 : 0, //13
    DateTime.now().year -7 : 0, //13
    DateTime.now().year -6 : 1, //13
    DateTime.now().year -5 : 1,  //10
    DateTime.now().year -4 : 2,  //10
    DateTime.now().year -3 : 4,  //10
    DateTime.now().year -2 : 7,  //7
    DateTime.now().year -1 : 10,  //3
    DateTime.now().year : 13     //1
  };

  Map<int, String> monthMap = {
    1 : 'JAN',
    2 : 'FEB',
    3 : 'MAR',
    4 : 'APR',
    5 : 'MAY',
    6 : 'JUN',
    7 : 'JUL',
    8 : 'AUG',
    9 : 'SEP',
    10 : 'OCT',
    11 : 'NOV',
    12 : 'DEC'
  };

  Map<int, int> weekDayWatches = {
    0 : 0,
    1 : 0,
    2 : 0,
    3 : 0,
    4 : 0,
    5 : 0,
    6 : 0,
    7 : 0,
  };

  Future<List<FlSpot>> weeklyWatchedEpisodes() async {
    var weekly = await FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).get();
    Map<int, int> watchedPerWeek = {
      2 : 0,
      7 : 0,
      12 : 0,
    };
    List<FlSpot> spots = [];
    weekly.docs.forEach((show) {
      // print(getWeekOfShow(show['lastWatched']));
      if (watchedPerWeek.containsKey(weeksAsX()[getWeekOfShow(show['lastWatched'])])){
        // print("contains");
        watchedPerWeek.update(weeksAsX()[getWeekOfShow(show['lastWatched'])], (value) => value+1);
        // return;
      }
      else{
        // print("no contains");
        // watchedPerWeek[getWeekOfShow(show['lastWatched'])] = 1;
      }
    });
    // print(watchedPerWeek);
    watchedPerWeek.forEach((key, value) {
      spots.add(FlSpot(key.toDouble(), value.toDouble()));
    });
    // print(spots);
    return spots;
  }

  monthlyWatchedEpisodes() async{
    var weekly = await FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).get();
    Map<int, int> watchedPerMonth = {
      2 : 0, //keys are X coordinates
      7 : 0,
      12 : 0,
    };
    List<FlSpot> spots = [];
    weekly.docs.forEach((show) {
      if (watchedPerMonth.containsKey(monthsAsX[getMonthOfShow(show['lastWatched'])])){
        watchedPerMonth.update(monthsAsX[getMonthOfShow(show['lastWatched'])], (value) => value+1);
      }
    });
    watchedPerMonth.forEach((key, value) {
      spots.add(FlSpot(key.toDouble(), value.toDouble()));
    });
    return spots;
  }

  yearlyWatchedEpisodes() async{
    var weekly = await FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).get();
    Map<int, int> watchedPerYear = {
      1 : 0, //keys are X coordinates
      2 : 0,
      4 : 0,
      7 : 0,
      10 : 0,
      13 : 0,
    };
    List<FlSpot> spots = [];
    weekly.docs.forEach((show) {
      if (watchedPerYear.containsKey(yearAsX[getYearOfShow(show['lastWatched'])])){
        watchedPerYear.update(yearAsX[getYearOfShow(show['lastWatched'])], (value) => value+1);
      }
      else{

      }
    });
    watchedPerYear.forEach((key, value) {
      spots.add(FlSpot(key.toDouble(), value.toDouble()));
    });
    return spots;
  }

  int getYearOfShow(dynamic time){
    return DateTime.parse(time).year;

  }
  int getMonthOfShow(dynamic time){
    return DateTime.parse(time).month;
  }

  int getWeekOfShow(dynamic time){
    int dayOfYear = int.parse(DateFormat("D").format(DateTime.parse(time)));
    // print(dayOfYear);
    int week = ((dayOfYear - DateTime.parse(time).weekday + 10) / 7).floor();
    // print(week);
    return week;
  }

  List<int> getWeeksOfYear(){
    int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    int week = ((dayOfYear - DateTime.now().weekday + 10) / 7).floor();
    return [week-2, week-1, week];
  }

  Map <int, int> weeksAsX() {
    return {
      getWeeksOfYear()[0]: 2,
      getWeeksOfYear()[1]: 7,
      getWeeksOfYear()[2]: 12,
    };
  }
  List<String> getMonths() {
    List<String> months = [];
    months.add(monthMap[DateTime.now().month -2]);
    months.add(monthMap[DateTime.now().month -1 ]);
    months.add(monthMap[DateTime.now().month ]);
    return months;
  }

  List<String> getYears() {
    List<String> years = [];
    years.add(((DateTime.now().year -8) % 2000).toString());
    years.add(((DateTime.now().year -6) % 2000).toString());
    years.add(((DateTime.now().year -4) % 2000).toString());
    years.add(((DateTime.now().year -2) % 2000).toString());
    years.add(((DateTime.now().year -1)% 2000).toString());
    years.add(((DateTime.now().year) % 2000).toString());
    return years;
  }

  double getOverallPercent() {
    double progress = 0.0;
    watchedShowList.forEach((element) {
      progress += element.calculateProgress();
    });
    progress /= watchedShowList.length;
    return progress;
  }

  getDaysOfShow() async{

    var weekly = await FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).get();
    weekly.docs.forEach((show) {
      if (weekDayWatches.containsKey(getDayOfShow(show['lastWatched']))){
        weekDayWatches.update(getDayOfShow(show['lastWatched']), (value) => value+1);
      }
    });
    return weekDayWatches;
  }

  int getDayOfShow(dynamic time) {
    return DateTime.parse(time).weekday -1;
  }
}