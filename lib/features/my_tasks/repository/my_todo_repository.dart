import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../models/my_todo_model.dart';

abstract class MyTodoRepository {
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
