import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<GetSplashEvent>((event, emit) {
      try {
        emit(SplashLoading());
        //fetch shows and stuff
        emit(SplashLoaded(event.successful));
      } catch (exception) {
        emit(const SplashError("Fetching stuff failed!"));
      }
    });
  }
}
