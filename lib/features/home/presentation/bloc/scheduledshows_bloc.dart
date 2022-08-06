import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:show_time/core/error/failures.dart';
import 'package:show_time/features/home/domain/usecases/get_scheduled_shows.dart';

part 'scheduledshows_event.dart';
part 'scheduledshows_state.dart';

class ScheduledShowsBloc
    extends Bloc<ScheduledShowsEvent, ScheduledShowsState> {
  final GetScheduledShows getScheduledShows;
  ScheduledShowsBloc({required this.getScheduledShows})
      : super(ScheduledShowsInitial()) {
    on<ScheduledShowsEvent>((event, emit) async {
      if (event is LoadScheduledShowsEvent) {
        //TODO: load scheduled shows
        emit(ScheduledShowsLoading());

        final failureOrScheduled = await getScheduledShows(Params());
       emit(failureOrScheduled.fold(
      (failure) => ScheduledShowsError(_mapFailureToMessage(failure)),
      (shows) => ScheduledShowsLoaded(shows),
    ));
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
