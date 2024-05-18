import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/base_error.dart';
import '../../../my_tasks/models/my_todo_model.dart';
import '../../repository/all_todos_repository.dart';

part 'all_todos_event.dart';
part 'all_todos_state.dart';

class AllTodosBloc extends Bloc<AllTodosEvent, AllTodosState> {
  final AllTodosRepository _allTodosRepository;
  AllTodosBloc(this._allTodosRepository) : super(AllTodosInitial()) {
    on<GetAllTodosEvent>((event, emit) async {
      emit(AllTodosLoading());
      final successOrFailure = await _allTodosRepository.getAllTodos();

      successOrFailure.fold(
        (error) => emit(GetAllTodosFailedState(error)),
        (allTodos) => emit(GetAllTodosSuccessState(allTodos)),
      );
    });

    on<GetAllPaginatedTodosEvent>((event, emit) async {
      emit(AllPaginatedTodosLoading());
      final successOrFailure =
          await _allTodosRepository.getRestOfTodos(event.limit, event.skip);

      successOrFailure.fold(
        (error) => emit(GetPaginatedTodosFailedState(error)),
        (allTodos) => emit(GetPaginatedTodosSuccessState(allTodos)),
      );
    });
  }
}
