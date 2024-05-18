// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/base_error.dart';
import '../../models/user_model.dart';
import '../../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepostitory;

  AuthBloc(this._authRepostitory) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final successOrFailuer = await _authRepostitory.login(
        username: event.username,
        password: event.password,
      );

      successOrFailuer.fold((error) {
        emit(AuthFailed(failure: error));
      }, (loginModel) async {
        emit(AuthSuccess(user: loginModel));
        token = await _authRepostitory.getToken();
        id = await _authRepostitory.getUserId();
        username = await _authRepostitory.getUserName();
        image = await _authRepostitory.getUserImage();
      });
    });

    on<AuthRefreshTokenEvent>((event, emit) async {
      emit(AuthLoading());
      final successOrFailuer = await _authRepostitory.refreshToken(event.token);
      successOrFailuer.fold((error) {
        emit(AuthFailed(failure: error));
      }, (loginModel) async {
        emit(AuthSuccess(user: loginModel));
        await _authRepostitory.setToken(event.token);
        token = event.token;
      });
    });

    on<AuthGetUserLocalInfo>((event, emit) async {
      token = await _authRepostitory.getToken();
      id = await _authRepostitory.getUserId();
      username = await _authRepostitory.getUserName();
      image = await _authRepostitory.getUserImage();
    });
  }

  String? token;
  String? id;
  String? username;
  String? image;
}
