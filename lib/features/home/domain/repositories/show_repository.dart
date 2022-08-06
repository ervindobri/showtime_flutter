import 'package:dartz/dartz.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/data/models/watched.dart';

abstract class ShowRepository {
  Future<Either<Failure, dynamic>> getScheduledShows();
  Future<Either<Failure, dynamic>> getWatchedShows(String email);

  List<WatchedTVShow> watchedShows = [];
  List<int> watchedShowIds = [];
  var notAiredList = <Episode>[];
  var sortedList = <WatchedTVShow>[];
}
