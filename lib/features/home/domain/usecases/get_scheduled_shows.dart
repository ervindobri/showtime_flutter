import 'package:show_time/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:show_time/core/usecases/usecase.dart';
import 'package:show_time/features/home/domain/repositories/show_repository.dart';

enum LoginType { email, biometry, google }

class GetScheduledShows implements UseCase<dynamic, Params> {
  final ShowRepository repository;
  GetScheduledShows(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(Params params) async {
    return await repository.getScheduledShows();
  }
}

class Params {
  Params();
}
