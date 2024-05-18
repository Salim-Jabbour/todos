import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  });

  Future<String?> getToken();
  Future<String?> getUserId();
  Future<String?> getUserName();
  Future<String?> getUserImage();

  Future<void> setToken(String token);
}
