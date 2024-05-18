import 'package:dartz/dartz.dart';

import 'package:maids_task_manager_app_test/core/errors/base_error.dart';

import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';

import '../../../core/errors/exception.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/profile_remote_data_source.dart';
import '../model/user_profile_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl(this._profileRemoteDataSource, this._networkInfo);
  @override
  Future<Either<Failure, MyTodoModel>> getRandomTodo() async {
    if (await _networkInfo.isConnected) {
      try {
        final addsuccess = await _profileRemoteDataSource.getRandomTodo();
        return addsuccess.fold(
          (failure) => Left(failure),
          (getRandomTodo) {
            return right(getRandomTodo);
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
  Future<Either<Failure, UserProfileModel>> getCurrentUser(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _profileRemoteDataSource.getCurrentUser(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (user) => right(user),
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }
}
