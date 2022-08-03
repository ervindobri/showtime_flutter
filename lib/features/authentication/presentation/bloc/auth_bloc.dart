import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/features/authentication/domain/usecases/post_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PostLoginCase postLogin;
  AuthBloc({required this.postLogin}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is EmailLoginEvent) {
        emit(AuthLoading());
        final failureOrLogin = await postLogin(Params(
            type: LoginType.email,
            email: event.username,
            password: event.password));

        _eitherLoadedOrErrorState(failureOrLogin);
      }
    });
  }
  void _eitherLoadedOrErrorState(Either<Failure, UserCredential> failureOrLogin) {
    emit(failureOrLogin.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (userInfo) => LoginSuccessful(userInfo),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CustomServerFailure:
        return (failure as CustomServerFailure).message;
      // case ServerFailure:
      //   return SERVER_FAILURE_MESSAGE;
      // case RedirectFailure:
      //   return GlobalStrings.redirectFailureMessage;
      // case CacheFailure:
      //   return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
