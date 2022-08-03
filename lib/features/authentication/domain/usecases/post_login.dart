import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:show_time/core/usecases/usecase.dart';
import 'package:show_time/features/authentication/domain/repositories/auth_repo.dart';

enum LoginType { email, biometry, google }

class PostLoginCase implements UseCase<UserCredential, Params> {
  final AuthRepository repository;
  PostLoginCase(this.repository);

  @override
  Future<Either<Failure, UserCredential>> call(Params params) async {
    return await repository.postLogin(
        params.type, params.email, params.password);
  }
}

class Params {
  final LoginType type;
  final String email;
  final String password;

  Params({required this.type, required this.email,required this.password});
}
