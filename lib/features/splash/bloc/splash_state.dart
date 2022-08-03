part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final bool successful;
  const SplashLoaded(this.successful);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SplashLoaded && other.successful == successful;
  }

  @override
  int get hashCode => successful.hashCode;
}

class SplashError extends SplashState {
  final String error;
  const SplashError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SplashError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
