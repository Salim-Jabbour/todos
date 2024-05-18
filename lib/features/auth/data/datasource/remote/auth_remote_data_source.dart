import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/services/debug_print.dart';
import '../../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  });

}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, UserModel>> login(
      {required String username, required String password}) async {
    final Response response;
    try {
      response = await dioClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 10080 // one week
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(UserModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      dbg(e);
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong),
        );
      }
    }
    return Left(ServerFailure());
  }

  
}
