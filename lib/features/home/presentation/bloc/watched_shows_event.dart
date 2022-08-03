part of 'watched_shows_bloc.dart';

@immutable
abstract class WatchedShowsEvent {}

class LoadWatchedShowsEvent extends WatchedShowsEvent {
  final String? email;

  LoadWatchedShowsEvent(this.email);
}
