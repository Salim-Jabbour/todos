import 'package:dartz/dartz.dart';

import 'package:maids_task_manager_app_test/core/errors/base_error.dart';

import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';

import '../../../core/errors/exception.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/all_todos_remote_data_source.dart';
import 'all_todos_repository.dart';

class AllTodosRepositoryImpl extends AllTodosRepository {
  final AllTodosRemoteDataSource _allTodosRemoteDataSource;
  final NetworkInfo _networkInfo;

  AllTodosRepositoryImpl(this._allTodosRemoteDataSource, this._networkInfo);
  @override
  Future<Either<Failure, MyTodos>> getAllTodos() async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess = await _allTodosRemoteDataSource.getAllTodos();

        return addsuccess.fold(
          (failure) => Left(failure),
          (getMyTodos) {
            return right(getMyTodos);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, MyTodos>> getRestOfTodos(int limit, int skip) async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess =
            await _allTodosRemoteDataSource.getRestOfTodos(limit, skip);

        return addsuccess.fold(
          (failure) => Left(failure),
          (getMyTodosPaged) {
            return right(getMyTodosPaged);
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
