import 'package:dartz/dartz.dart';

import 'package:maids_task_manager_app_test/core/errors/base_error.dart';

import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';

import '../../../core/errors/exception.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/services/debug_print.dart';
import '../../auth/data/datasource/local/auth_local_data_source.dart';
import '../../auth/models/user_model.dart';
import '../data/datasource/local/my_todo_local_data_source.dart';
import '../data/datasource/remote/my_todo_remote_data_source.dart';
import 'my_todo_repository.dart';

class MyTodoRepositoryImpl extends MyTodoRepository {
  final MyTodoRemoteDataSource _myTodoRemoteDataSource;
  final MyTodoLocalDataSource _myTodoLocalDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final NetworkInfo _networkInfo;

  MyTodoRepositoryImpl(
    this._myTodoRemoteDataSource,
    this._networkInfo,
    this._authLocalDataSource,
    this._myTodoLocalDataSource,
  );

  @override
  Future<Either<Failure, MyTodos>> getAllMyTodos(
      {required String userId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess =
            await _myTodoRemoteDataSource.getAllMyTodos(userId: userId);

        return addsuccess.fold(
          (failure) => Left(failure),
          (getMyTodos) async {
            // set the remote data to local data after deleting the local db
            List<MyTodoModelOffline> todos = [];
            for (MyTodoModel todo in getMyTodos.todos) {
              MyTodoModelOffline temp = MyTodoModelOffline(
                todo: todo.todo,
                completed: todo.completed == true ? 1 : 0,
                userId: todo.userId,
              );
              todos.add(temp);
            }
            dbg(todos.length);
            await _myTodoLocalDataSource.clearDatabase();
            await _myTodoLocalDataSource.insertTodos(todos);
            return right(getMyTodos);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else if (!await _networkInfo.isConnected) {
      List<MyTodoModelOffline>? todoList =
          await _myTodoLocalDataSource.getAllTodos();
      List<MyTodoModel> todos = [];

      for (MyTodoModelOffline todo in todoList!) {
        MyTodoModel temp = MyTodoModel(
          id: todo.id ?? 0,
          todo: todo.todo,
          completed: todo.completed == 1 ? true : false,
          userId: todo.userId,
        );
        todos.add(temp);
      }
      return right(MyTodos(
        todos: todos,
        total: todos.length,
        skip: 0,
        limit: todos.length,
      ));
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, MyTodoModel>> addTodo(
      {required String todo,
      required int completed,
      required int userId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess = await _myTodoRemoteDataSource.addTodo(
          todo: todo,
          completed: completed,
          userId: userId,
        );

        return addsuccess.fold(
          (failure) => Left(failure),
          (addTodo) async {
            await _myTodoLocalDataSource.createTodo(MyTodoModelOffline(
              todo: todo,
              completed: completed,
              userId: userId,
            ));
            return right(addTodo);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else if (!await _networkInfo.isConnected) {
      await _myTodoLocalDataSource.createTodo(MyTodoModelOffline(
        todo: todo,
        completed: completed,
        userId: userId,
      ));
      return right(MyTodoModel(
        id: 1,
        todo: todo,
        completed: completed == 1 ? true : false,
        userId: userId,
      ));
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, MyTodoModel>> updateTodo(
      {required String todoId, required bool completed}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess = await _myTodoRemoteDataSource.updateTodo(
          completed: completed,
          todoId: todoId,
        );

        return addsuccess.fold(
          (failure) => Left(failure),
          (updateTodo) {
            return right(updateTodo);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    // TODO: add else if condition to update the offline data
    else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo({required String todoId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess =
            await _myTodoRemoteDataSource.deleteTodo(todoId: todoId);

        return addsuccess.fold(
          (failure) => Left(failure),
          (deleteTodo) {
            return right(deleteTodo);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    // TODO: add else if condition to delete the offline data
    else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> refreshToken(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _myTodoRemoteDataSource.refreshToken(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (user) async {
            await _authLocalDataSource.setUserToken(user.token);
            return right(user);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }
}
