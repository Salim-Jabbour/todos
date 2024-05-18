import 'package:dartz/dartz.dart';

import 'package:maids_task_manager_app_test/core/errors/base_error.dart';

import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';

import '../../../core/errors/exception.dart';
import '../../../core/network/network_info.dart';
import '../../auth/data/datasource/local/auth_local_data_source.dart';
import '../../auth/models/user_model.dart';
import '../data/datasource/remote/my_todo_remote_data_source.dart';
import 'my_todo_repository.dart';

class MyTodoRepositoryImpl extends MyTodoRepository {
  final MyTodoRemoteDataSource _myTodoRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final NetworkInfo _networkInfo;

  // TODO: implement sqflite

  MyTodoRepositoryImpl(this._myTodoRemoteDataSource, this._networkInfo,
      this._authLocalDataSource);
  @override
  Future<Either<Failure, MyTodos>> getAllMyTodos(
      {required String userId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess =
            await _myTodoRemoteDataSource.getAllMyTodos(userId: userId);

        return addsuccess.fold(
          (failure) => Left(failure),
          (getMyTodos) {
            return right(getMyTodos);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } // TODO: add else if condition to get the offline data

    else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, MyTodoModel>> addTodo(
      {required String todo,
      required bool completed,
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
          (addTodo) {
            return right(addTodo);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    // TODO: add else if condition to get the offline data
    else {
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
