part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class GetSplashEvent extends SplashEvent {
  final bool successful;
  GetSplashEvent(this.successful);
}
