import '../core/network/network_info.dart';
import '../features/all_todos/data/datasource/remote/all_todos_remote_data_source.dart';
import '../features/all_todos/presentation/bloc/all_todos_bloc.dart';
import '../features/all_todos/repository/all_todos_repository.dart';
import '../features/all_todos/repository/all_todos_repository_impl.dart';
import 'auth_injection.dart';

Future<void> allTodoInjection() async {
  //bloc
  locator.registerFactory(
    () => AllTodosBloc(locator.get<AllTodosRepository>()),
  );

  //Repository
  locator.registerLazySingleton<AllTodosRepository>(
    () => AllTodosRepositoryImpl(
      locator.get<AllTodosRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //Data source
  locator.registerLazySingleton<AllTodosRemoteDataSource>(
    () => AllTodosRemoteDataSourceImpl(locator.get()),
  );
}
