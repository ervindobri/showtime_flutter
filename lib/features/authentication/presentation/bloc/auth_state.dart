part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccessful extends AuthState {
  final UserCredential user;
  LoginSuccessful(this.user);
}

class LoginFailure extends AuthState {}

class LogoutFailure extends AuthState {}

class RegisterSuccessful extends AuthState {}

class RegisterFailure extends AuthState {}

class Error extends AuthState {
  final String message;

  Error(this.message);
}
