part of 'watched_shows_bloc.dart';

@immutable
abstract class WatchedShowsState {}

class WatchedShowsInitial extends WatchedShowsState {}

class WatchedShowsLoading extends WatchedShowsState {}

class WatchedShowsLoaded extends WatchedShowsState {
  final dynamic shows;

  WatchedShowsLoaded(this.shows);
}

class WatchedShowsError extends WatchedShowsState {
  final String message;

  WatchedShowsError(this.message);
}
