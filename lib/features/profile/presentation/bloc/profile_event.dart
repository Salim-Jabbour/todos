part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetRandomTodoEvent extends ProfileEvent {}


class ProfileGetCurrentUserEvent extends ProfileEvent {
  final String token;

  ProfileGetCurrentUserEvent(this.token);
}