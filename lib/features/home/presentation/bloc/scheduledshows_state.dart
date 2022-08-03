part of 'scheduledshows_bloc.dart';

@immutable
abstract class ScheduledShowsState {}

class ScheduledShowsInitial extends ScheduledShowsState {}

class ScheduledShowsLoading extends ScheduledShowsState {}

class ScheduledShowsLoaded extends ScheduledShowsState {
  final List shows;

  ScheduledShowsLoaded(this.shows);
}

class ScheduledShowsError extends ScheduledShowsState {
  final String message;

  ScheduledShowsError(this.message);
}
