import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../my_tasks/models/my_todo_model.dart';

abstract class AllTodosRemoteDataSource {
  Future<Either<Failure, MyTodos>> getAllTodos();
  Future<Either<Failure, MyTodos>> getRestOfTodos(int limit, int skip);
}

class AllTodosRemoteDataSourceImpl extends AllTodosRemoteDataSource {
  final Dio dioClient;

  AllTodosRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, MyTodos>> getAllTodos() async {
    final Response response;
    try {
      response = await dioClient.get('/todos');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(MyTodos.fromJson(response.data as Map<String, dynamic>));
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
  Future<Either<Failure, MyTodos>> getRestOfTodos(int limit, int skip) async {
    final Response response;
    try {
      response = await dioClient.get('/todos?limit=$limit&skip=$skip');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(MyTodos.fromJson(response.data as Map<String, dynamic>));
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
