part of 'all_todos_bloc.dart';

@immutable
sealed class AllTodosEvent {}

class GetAllTodosEvent extends AllTodosEvent {}

class GetAllPaginatedTodosEvent extends AllTodosEvent {
  final int limit;
  final int skip;

  GetAllPaginatedTodosEvent({required this.limit, required this.skip});
}
