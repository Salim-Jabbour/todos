import 'package:dartz/dartz.dart';

import 'package:maids_task_manager_app_test/core/errors/base_error.dart';

import 'package:maids_task_manager_app_test/features/auth/models/user_model.dart';

import '../../../core/errors/exception.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/services/debug_print.dart';
import '../data/datasource/local/auth_local_data_source.dart';
import '../data/datasource/remote/auth_remote_data_source.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, UserModel>> login(
      {required String username, required String password}) async {
    dbg("IM here");
    if (await _networkInfo.isConnected) {
      dbg("IM here");

      try {
        final addSuccess = await _authRemoteDataSource.login(
          username: username,
          password: password,
        );

        return addSuccess.fold((failure) {
          return Left(failure);
        }, (loginResponse) async {
          await _authLocalDataSource.setUserId(loginResponse.id.toString());

          await _authLocalDataSource.setUserToken(loginResponse.token);

          await _authLocalDataSource.setUserName(loginResponse.username);

          await _authLocalDataSource.setUserImage(loginResponse.image);

          return right(loginResponse);
        });
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

 
  @override
  Future<String?> getToken() async {
    return await _authLocalDataSource.getUserToken();
  }

  @override
  Future<String?> getUserId() async {
    return await _authLocalDataSource.getUserId();
  }

  @override
  Future<String?> getUserName() async {
    return await _authLocalDataSource.getUserName();
  }

  @override
  Future<String?> getUserImage() async {
    return await _authLocalDataSource.getUserImage();
  }

  @override
  Future<void> setToken(String token) async {
    _authLocalDataSource.setUserToken(token);
  }
}
