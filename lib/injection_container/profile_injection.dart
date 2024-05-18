import '../core/network/network_info.dart';
import '../features/profile/data/datasource/remote/profile_remote_data_source.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/profile/repository/profile_repository.dart';
import '../features/profile/repository/profile_repository_impl.dart';
import 'auth_injection.dart';

Future<void> profileInjection() async {
  //bloc
  locator.registerFactory(
    () => ProfileBloc(locator.get<ProfileRepository>()),
  );

  //Repository
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      locator.get<ProfileRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //Data sources
  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(locator.get()),
  );
}
