part of 'my_todo_bloc.dart';

@immutable
sealed class MyTodoState {}

final class MyTodoInitial extends MyTodoState {}

final class MyTodoLoading extends MyTodoState {}

// get Todos
final class GetTodosSuccessState extends MyTodoState {
  final MyTodos myTodos;

  GetTodosSuccessState(this.myTodos);
}

final class GetTodosFailedState extends MyTodoState {
  final Failure failure;

  GetTodosFailedState(this.failure);
}

// add
final class AddTodoSuccessState extends MyTodoState {
  final MyTodoModel myTodoModel;

  AddTodoSuccessState(this.myTodoModel);
}

final class AddTodoFailedState extends MyTodoState {
  final Failure failure;

  AddTodoFailedState(this.failure);
}

// update
final class UpdateTodoSuccessState extends MyTodoState {
  final MyTodoModel myTodoModel;

  UpdateTodoSuccessState(this.myTodoModel);
}

final class UpdateTodoFailedState extends MyTodoState {
  final Failure failure;

  UpdateTodoFailedState(this.failure);
}

// delete
final class DeleteTodoSuccessState extends MyTodoState {
  final String message;

  DeleteTodoSuccessState(this.message);
}

final class DeleteTodoFailedState extends MyTodoState {
  final Failure failure;

  DeleteTodoFailedState(this.failure);
}

final class RefreshTokenSuccessState extends MyTodoState {
  final UserModel userModel;

  RefreshTokenSuccessState(this.userModel);
}

final class RefreshTokenFailedState extends MyTodoState {
  final Failure failure;

  RefreshTokenFailedState(this.failure);
}
