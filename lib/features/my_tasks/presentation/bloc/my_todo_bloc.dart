import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/base_error.dart';
import '../../../auth/models/user_model.dart';
import '../../models/my_todo_model.dart';
import '../../repository/my_todo_repository.dart';

part 'my_todo_event.dart';
part 'my_todo_state.dart';

class MyTodoBloc extends Bloc<MyTodoEvent, MyTodoState> {
  final MyTodoRepository _myTodoRepository;
  MyTodoBloc(this._myTodoRepository) : super(MyTodoInitial()) {
    // get event
    on<GetTodosEvent>((event, emit) async {
      emit(MyTodoLoading());
      final successOrFailure =
          await _myTodoRepository.getAllMyTodos(userId: event.userId);
      successOrFailure.fold(
        (error) => emit(GetTodosFailedState(error)),
        (todosModel) => emit(GetTodosSuccessState(todosModel)),
      );
    });

    // add event
    on<AddTodoEvent>((event, emit) async {
      emit(MyTodoLoading());
      final successOrFailure = await _myTodoRepository.addTodo(
        todo: event.todo,
        completed: event.completed,
        userId: event.userId,
      );
      successOrFailure.fold(
        (error) => emit(AddTodoFailedState(error)),
        (addTodo) => emit(AddTodoSuccessState(addTodo)),
      );
    });

    // update event
    on<UpdateTodoEvent>((event, emit) async {
      emit(MyTodoLoading());
      final successOrFailure = await _myTodoRepository.updateTodo(
          completed: event.completed, todoId: event.todoId);
      successOrFailure.fold(
        (error) => emit(UpdateTodoFailedState(error)),
        (updateTodo) {
          emit(UpdateTodoSuccessState(updateTodo));
          emit(MyTodoInitial());
        },
      );
    });

    // delete event
    on<DeleteTodoEvent>((event, emit) async {
      emit(MyTodoLoading());
      final successOrFailure =
          await _myTodoRepository.deleteTodo(todoId: event.todoId);
      successOrFailure.fold(
        (error) => emit(DeleteTodoFailedState(error)),
        (deleteTodoMsg) {
          emit(DeleteTodoSuccessState(deleteTodoMsg));
          emit(MyTodoInitial());
        },
      );
    });

    // refresh token state
    on<TodoRefreshTokenEvent>((event, emit) async {
      emit(MyTodoLoading());
      final successOrFailure =
          await _myTodoRepository.refreshToken(event.token);
      successOrFailure.fold(
        (error) => emit(RefreshTokenFailedState(error)),
        (refreshToken) {
          emit(RefreshTokenSuccessState(refreshToken));
          emit(MyTodoInitial());
        },
      );
    });
  }
}
