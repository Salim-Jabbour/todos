part of 'my_todo_bloc.dart';

@immutable
sealed class MyTodoEvent {}

class GetTodosEvent extends MyTodoEvent {
  final String userId;

  GetTodosEvent({required this.userId});
}

class AddTodoEvent extends MyTodoEvent {
  final String todo;
  final int completed;
  final int userId;

  AddTodoEvent(
      {required this.todo, required this.completed, required this.userId});
}

class UpdateTodoEvent extends MyTodoEvent {
  final String todoId;
  final bool completed;

  UpdateTodoEvent({required this.todoId, required this.completed});
}

class DeleteTodoEvent extends MyTodoEvent {
  final String todoId;

  DeleteTodoEvent({required this.todoId});
}

class TodoRefreshTokenEvent extends MyTodoEvent {
  final String token;

  TodoRefreshTokenEvent(this.token);
}
