part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent(this.username, this.password);
}

class EmailLoginEvent extends LoginEvent {
  EmailLoginEvent(String username, String password) : super(username, password);
}

class LogoutEvent extends AuthEvent {}

class GoogleLoginEvent extends AuthEvent {}

class BiometryLoginEvent extends AuthEvent {}
