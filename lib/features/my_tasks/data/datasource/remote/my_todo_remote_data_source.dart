import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../models/my_todo_model.dart';

abstract class MyTodoRemoteDataSource {
  Future<Either<Failure, MyTodos>> getAllMyTodos({
    required String userId,
  });

  Future<Either<Failure, MyTodoModel>> addTodo({
    required String todo,
    required bool completed,
    required int userId,
  });

  Future<Either<Failure, MyTodoModel>> updateTodo({
    required String todoId,
    required bool completed,
  });
  Future<Either<Failure, String>> deleteTodo({
    required String todoId,
  });
}

class MyTodoRemoteDataSourceImpl extends MyTodoRemoteDataSource {
  final Dio dioClient;

  MyTodoRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, MyTodos>> getAllMyTodos(
      {required String userId}) async {
    final Response response;
    try {
      response = await dioClient.get('/todos/user/$userId');
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
  Future<Either<Failure, MyTodoModel>> addTodo(
      {required String todo,
      required bool completed,
      required int userId}) async {
    final Response response;
    try {
      response = await dioClient.post(
        '/todos/add',
        data: {
          'todo': todo,
          'completed': completed,
          'userId': userId,
        },
      );
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
  Future<Either<Failure, MyTodoModel>> updateTodo(
      {required String todoId, required bool completed}) async {
    final Response response;
    try {
      response = await dioClient.put(
        '/todos/$todoId',
        data: {'completed': completed},
      );
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
  Future<Either<Failure, String>> deleteTodo({required String todoId}) async {
    final Response response;
    try {
      response = await dioClient.delete('/todos/$todoId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("Todo deleted successfully");
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
