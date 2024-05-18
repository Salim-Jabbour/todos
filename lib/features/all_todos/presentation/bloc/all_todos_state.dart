part of 'all_todos_bloc.dart';

@immutable
sealed class AllTodosState {}

final class AllTodosInitial extends AllTodosState {}

final class AllTodosLoading extends AllTodosState {}

final class AllPaginatedTodosLoading extends AllTodosState {}

final class GetAllTodosSuccessState extends AllTodosState {
  final MyTodos allTodos;

  GetAllTodosSuccessState(this.allTodos);
}

final class GetAllTodosFailedState extends AllTodosState {
  final Failure failure;

  GetAllTodosFailedState(this.failure);
}

final class GetPaginatedTodosSuccessState extends AllTodosState {
  final MyTodos allTodos;

  GetPaginatedTodosSuccessState(this.allTodos);
}

final class GetPaginatedTodosFailedState extends AllTodosState {
  final Failure failure;

  GetPaginatedTodosFailedState(this.failure);
}
