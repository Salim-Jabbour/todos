part of 'my_todo_bloc.dart';

@immutable
sealed class MyTodoState extends Equatable {
  const MyTodoState();
  @override
  List<Object> get props => [];
}

final class MyTodoInitial extends MyTodoState {}

final class MyTodoLoading extends MyTodoState {}

// get Todos
final class GetTodosSuccessState extends MyTodoState {
  final MyTodos myTodos;

  const GetTodosSuccessState(this.myTodos);
}

final class GetTodosFailedState extends MyTodoState {
  final Failure failure;

 const GetTodosFailedState(this.failure);
}

// add
final class AddTodoSuccessState extends MyTodoState {
  final MyTodoModel myTodoModel;

 const AddTodoSuccessState(this.myTodoModel);
}

final class AddTodoFailedState extends MyTodoState {
  final Failure failure;

 const AddTodoFailedState(this.failure);
}

// update
final class UpdateTodoSuccessState extends MyTodoState {
  final MyTodoModel myTodoModel;

 const UpdateTodoSuccessState(this.myTodoModel);
}

final class UpdateTodoFailedState extends MyTodoState {
  final Failure failure;

 const UpdateTodoFailedState(this.failure);
}

// delete
final class DeleteTodoSuccessState extends MyTodoState {
  final String message;

 const DeleteTodoSuccessState(this.message);
}

final class DeleteTodoFailedState extends MyTodoState {
  final Failure failure;

 const DeleteTodoFailedState(this.failure);
}

final class RefreshTokenSuccessState extends MyTodoState {
  final UserModel userModel;

 const RefreshTokenSuccessState(this.userModel);
}

final class RefreshTokenFailedState extends MyTodoState {
  final Failure failure;

 const RefreshTokenFailedState(this.failure);
}
