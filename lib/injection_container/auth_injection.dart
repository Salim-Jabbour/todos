import '../core/network/network_info.dart';
import '../features/auth/data/datasource/local/auth_local_data_source.dart';
import '../features/auth/data/datasource/remote/auth_remote_data_source.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/repository/auth_repository_impl.dart';

GetIt locator = GetIt.instance;

Future<void> authInjection() async {
  //bloc
  locator.registerFactory(
    () => AuthBloc(locator.get<AuthRepository>()),
  );

  //Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator.get<AuthRemoteDataSource>(),
      locator.get<AuthLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //Data sources
  locator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(locator.get()));

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator.get()),
  );
}
