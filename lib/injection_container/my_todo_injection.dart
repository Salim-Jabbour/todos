import '../core/network/network_info.dart';
import '../features/my_tasks/data/datasource/remote/my_todo_remote_data_source.dart';
import '../features/my_tasks/presentation/bloc/my_todo_bloc.dart';
import '../features/my_tasks/repository/my_todo_repository.dart';
import '../features/my_tasks/repository/my_todo_repository_impl.dart';
import 'auth_injection.dart';

Future<void> myTodoInjection() async {
  //bloc
  locator.registerFactory(
    () => MyTodoBloc(locator.get<MyTodoRepository>()),
  );

  //Repository
  locator.registerLazySingleton<MyTodoRepository>(
    () => MyTodoRepositoryImpl(
      locator.get<MyTodoRemoteDataSource>(),
      // TODO:
      // locator.get<AuthLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //Data sources
  // TODO:
  // locator.registerLazySingleton<MyTodoLocalDataSource>(
  // () => MyTodoLocalDataSource(locator.get()));

  locator.registerLazySingleton<MyTodoRemoteDataSource>(
    () => MyTodoRemoteDataSourceImpl(locator.get()),
  );
}
