part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileGetRandomTodoSuccess extends ProfileState {
  final MyTodoModel myTodoModel;

  ProfileGetRandomTodoSuccess(this.myTodoModel);
}

final class ProfileGetRandomTodoFailed extends ProfileState {
  final Failure failure;

  ProfileGetRandomTodoFailed(this.failure);
}

final class ProfileGetUserSuccess extends ProfileState {
  final UserProfileModel userModel;

  ProfileGetUserSuccess(this.userModel);
}

final class ProfileGetUserFailed extends ProfileState {
  final Failure failure;

  ProfileGetUserFailed(this.failure);
}
