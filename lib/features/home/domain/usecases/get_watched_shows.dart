import 'package:show_time/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:show_time/core/usecases/usecase.dart';
import 'package:show_time/features/home/domain/repositories/show_repository.dart';


class GetWatchedShows implements UseCase<dynamic, Params> {
  final ShowRepository repository;
  GetWatchedShows(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(Params params) async {
    return await repository.getWatchedShows(params.email);
  }
}

class Params {
  final String email;
  Params({required this.email});
}
