import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_time/core/error/exceptions.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/core/network/network_info.dart';
import 'package:show_time/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:show_time/features/authentication/domain/repositories/auth_repo.dart';
import 'package:show_time/features/authentication/domain/usecases/post_login.dart';

typedef _UsecaseChooser = Future<UserCredential> Function();

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserCredential>> postLogin(
      LoginType type, String email, String password) async {
    return await _postLogin(() {
      return remoteDataSource.postLogin(type, email, password);
    });
  }

  @override
  Future<Either<Failure, UserCredential>> postRegister(
      String email, String password) {
    // TODO: implement postRegister
    throw UnimplementedError();
  }

  Future<Either<Failure, UserCredential>> _postLogin(
    _UsecaseChooser getUsecase,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteContentRate = await getUsecase();
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
