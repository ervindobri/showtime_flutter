import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/features/home/domain/usecases/get_watched_shows.dart';
part 'watched_shows_event.dart';
part 'watched_shows_state.dart';

class WatchedShowsBloc extends Bloc<WatchedShowsEvent, WatchedShowsState> {
  final GetWatchedShows getWatchedShows;
  WatchedShowsBloc({required this.getWatchedShows})
      : super(WatchedShowsInitial()) {
    on<WatchedShowsEvent>((event, emit) async {
      if (event is LoadWatchedShowsEvent) {
        //TODO: load scheduled shows
        emit(WatchedShowsLoading());
        if (event.email != null) {
          final failureOrScheduled =
              await getWatchedShows(Params(email: event.email!));
          emit(failureOrScheduled.fold(
            (failure) => WatchedShowsError(_mapFailureToMessage(failure)),
            (shows) => WatchedShowsLoaded(shows),
          ));
        } else {
          emit(WatchedShowsError("No user info"));
        }
      }
    });
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
