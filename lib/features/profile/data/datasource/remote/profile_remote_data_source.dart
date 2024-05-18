import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../my_tasks/models/my_todo_model.dart';
import '../../../model/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, MyTodoModel>> getRandomTodo();
  Future<Either<Failure, UserProfileModel>> getCurrentUser(String token);
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final Dio dioClient;

  ProfileRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, MyTodoModel>> getRandomTodo() async {
    final Response response;
    try {
      response = await dioClient.get('/todos/random');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MyTodoModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
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

  @override
  Future<Either<Failure, UserProfileModel>> getCurrentUser(String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'Authorization': 'Bearer $token'});
      response = await dioClient.get('/auth/me');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            UserProfileModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
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
