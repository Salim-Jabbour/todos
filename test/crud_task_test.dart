import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task_manager_app_test/core/errors/base_error.dart';
import 'package:maids_task_manager_app_test/core/network/network_info.dart';
import 'package:maids_task_manager_app_test/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/data/datasource/local/my_todo_local_data_source.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/data/datasource/remote/my_todo_remote_data_source.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/repository/my_todo_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crud_task_test.mocks.dart';

@GenerateMocks([
  MyTodoRemoteDataSource,
  NetworkInfo,
  MyTodoLocalDataSource,
  AuthLocalDataSource
])
void main() {
  late MyTodoRepositoryImpl repository;
  late MockMyTodoRemoteDataSource mockRemoteDataSource;
  late MockMyTodoLocalDataSource mockMyTodoLocalDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMyTodoRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockMyTodoLocalDataSource = MockMyTodoLocalDataSource();
    repository = MyTodoRepositoryImpl(
      mockRemoteDataSource,
      mockNetworkInfo,
      mockLocalDataSource,
      mockMyTodoLocalDataSource,
    );
  });

  group("My Todos", () {
    // setup
    const tTodo = 'wash my car';
    const tCompleted = 0;
    const tuCompleted = false;
    const tfuserId = 1000;
    const tuserId = 5;
    final tAddTodoModel = MyTodoModel(
      id: 151,
      todo: tTodo,
      completed: false,
      userId: tuserId,
    );
    final tfAddTodoModel = Failure(
      message: "User with id '$tfuserId' not found",
      statusCode: 404,
    );
    final tUpdateTodoModel = MyTodoModel(
      id: 1,
      todo: "Do something nice for someone I care about",
      completed: false,
      userId: 26,
    );
    final tAllTasks = MyTodos(
      skip: 0,
      limit: 3,
      total: 3,
      todos: [
        MyTodoModel(
          id: 19,
          todo: "Create a compost pile",
          completed: true,
          userId: 5,
        ),
        MyTodoModel(
          id: 85,
          todo: "Make a budget",
          completed: true,
          userId: 5,
        ),
        MyTodoModel(
          id: 103,
          todo: "Go to a local thrift shop",
          completed: true,
          userId: 26,
        ),
      ],
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      // do:

      // add success
      test(
          "Adding todo SUCCESS: should return remote data when the call to remote data source is successful",
          () async {
        when(mockRemoteDataSource.addTodo(
                todo: anyNamed('todo'),
                completed: anyNamed('completed'),
                userId: anyNamed('userId')))
            .thenAnswer((_) async => right(tAddTodoModel));

        final result = await repository.addTodo(
          todo: tTodo,
          completed: tCompleted,
          userId: tuserId,
        );
        verify(mockRemoteDataSource.addTodo(
          todo: tTodo,
          completed: tCompleted,
          userId: tuserId,
        ));
        // test
        expect(result, equals(right(tAddTodoModel)));
      });

      // add failed
      test(
          "Adding todo FAILED: should return remote data when the call to remote data source is Failed",
          () async {
        when(mockRemoteDataSource.addTodo(
                todo: anyNamed('todo'),
                completed: anyNamed('completed'),
                userId: anyNamed('userId')))
            .thenAnswer((_) async => left(tfAddTodoModel));

        final result = await repository.addTodo(
          todo: tTodo,
          completed: tCompleted,
          userId: tfuserId,
        );
        verify(mockRemoteDataSource.addTodo(
          todo: tTodo,
          completed: tCompleted,
          userId: tfuserId,
        ));
        // test
        expect(result, equals(left(tfAddTodoModel)));
      });

      // update
      test(
          "Updating todo SUCCESS: should return remote data when the call to remote data source is successful",
          () async {
        when(mockRemoteDataSource.updateTodo(
                completed: anyNamed('completed'), todoId: anyNamed('todoId')))
            .thenAnswer((_) async => right(tUpdateTodoModel));

        final result = await repository.updateTodo(
          completed: tuCompleted,
          todoId: 1.toString(),
        );
        verify(mockRemoteDataSource.updateTodo(
          completed: tuCompleted,
          todoId: 1.toString(),
        ));
        // test
        expect(result, equals(right(tUpdateTodoModel)));
      });

      // delete
      test(
          "Deleting todo SUCCESS: should return remote data when the call to remote data source is successful",
          () async {
        when(mockRemoteDataSource.deleteTodo(todoId: anyNamed('todoId')))
            .thenAnswer((_) async => right("Deleted successfully"));

        final result = await repository.deleteTodo(
          todoId: 1.toString(),
        );
        verify(mockRemoteDataSource.deleteTodo(
          todoId: 1.toString(),
        ));
        // test
        expect(result, equals(right("Deleted successfully")));
      });

      // read
      test(
          "Reading todo SUCCESS: should return remote data when the call to remote data source is successful",
          () async {
        when(mockRemoteDataSource.getAllMyTodos(userId: anyNamed('userId')))
            .thenAnswer((_) async => right(tAllTasks));

        final result = await repository.getAllMyTodos(
          userId: 5.toString(),
        );
        verify(mockRemoteDataSource.getAllMyTodos(
          userId: 5.toString(),
        ));
        // test
        expect(result, equals(right(tAllTasks)));
      });
    });
  });
}
