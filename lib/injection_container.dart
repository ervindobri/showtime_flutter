import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:show_time/core/network/network_info.dart';
import 'package:show_time/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:show_time/features/authentication/data/repositories/auth_repository.dart';
import 'package:show_time/features/authentication/domain/repositories/auth_repo.dart';
import 'package:show_time/features/authentication/domain/usecases/post_login.dart';
import 'package:show_time/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:show_time/features/home/data/datasources/show_remote_datasource.dart';
import 'package:show_time/features/home/data/repositories/show_repository_impl.dart';
import 'package:show_time/features/home/domain/repositories/show_repository.dart';
import 'package:show_time/features/home/domain/usecases/get_scheduled_shows.dart';
import 'package:show_time/features/home/domain/usecases/get_watched_shows.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/splash/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<bool> isReady() async {
  // return await sl.isRegistered<ObtainAuthTokenBloc>();
  return true;
}

Future<void> init() async {
  // bloc -> usecases -> repo - > datasource
  registerSplash();
  registerAuth();
  registerShows();

  // sl.registerLazySingleton(() => InputConverter());
  //TODO: register database etc.
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

void registerShows() {
  sl.registerFactory(
    () => ScheduledShowsBloc(getScheduledShows: sl()),
  );
  sl.registerFactory(
    () => WatchedShowsBloc(getWatchedShows: sl()),
  );
  sl.registerLazySingleton(() => GetScheduledShows(sl()));
  sl.registerLazySingleton(() => GetWatchedShows(sl()));
  sl.registerLazySingleton<ShowRepository>(
    () => ShowRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ShowRemoteDataSource>(
    () => ShowRemoteDataSourceImpl(firestore: sl()),
  );
}

void registerSplash() {
  sl.registerFactory(
    () => SplashBloc(),
  );
}

void registerAuth() {
  sl.registerFactory(
    () => AuthBloc(postLogin: sl()),
  );
  sl.registerLazySingleton(() => PostLoginCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebase: sl()),
  );
}
