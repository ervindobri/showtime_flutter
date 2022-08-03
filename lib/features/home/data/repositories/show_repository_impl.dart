import 'package:dartz/dartz.dart';
import 'package:show_time/core/error/exceptions.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/core/network/network_info.dart';
import 'package:show_time/features/home/data/datasources/show_remote_datasource.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/domain/repositories/show_repository.dart';
import 'package:show_time/features/home/data/models/watched.dart';

typedef Future<dynamic> _UsecaseChooserWatched();

class ShowRepositoryImpl extends ShowRepository {
  final ShowRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ShowRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, dynamic>> getScheduledShows() async {
    return await _getShows(() {
      return remoteDataSource.getScheduledShows();
    });
  }

  @override
  Future<Either<Failure, dynamic>> getWatchedShows(String email) async {
    return await _getShows(() {
      return remoteDataSource.getWatchedShows(email);
    });
  }

  Future<Either<Failure, dynamic>> _getShows(
      _UsecaseChooserWatched getUseCase) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteContentRate = await getUseCase();
        return Right(remoteContentRate);
      } on CustomServerException catch (e) {
        return Left(CustomServerFailure(e.message));
      } on RedirectException catch (e) {
        return Left(RedirectFailure(e.cause));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
