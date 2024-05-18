import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../../my_tasks/models/my_todo_model.dart';

abstract class AllTodosRepository {
  Future<Either<Failure, MyTodos>> getAllTodos();
  Future<Either<Failure, MyTodos>> getRestOfTodos(int limit, int skip);
}
