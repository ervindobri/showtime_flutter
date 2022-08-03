import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CustomServerFailure extends Failure {
  final String message;

  CustomServerFailure(this.message);
}

class CacheFailure extends Failure {}

class RedirectFailure extends Failure {
  final String cause;

  RedirectFailure(this.cause);
}

class ConnectionFailure extends Failure {}
