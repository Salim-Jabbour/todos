import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../../my_tasks/models/my_todo_model.dart';
import '../model/user_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, MyTodoModel>> getRandomTodo();
  Future<Either<Failure, UserProfileModel>> getCurrentUser(String token);
}
