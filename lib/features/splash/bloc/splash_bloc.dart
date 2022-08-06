import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial());

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is GetSplashEvent) {
      try {
        yield SplashLoading();
        //fetch shows and stuff
        yield SplashLoaded(event.successful);
      } catch (exception) {
        yield const SplashError("Fetching stuff failed!");
      }
    }
  }
}
