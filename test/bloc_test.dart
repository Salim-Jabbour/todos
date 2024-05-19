import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/models/my_todo_model.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/presentation/bloc/my_todo_bloc.dart';
import 'package:maids_task_manager_app_test/features/my_tasks/repository/my_todo_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bloc_test.mocks.dart';

@GenerateMocks([MyTodoRepository])
void main() {
  late MyTodoBloc myTodoBloc;
  late MockMyTodoRepository repository;

  setUp(() {
    repository = MockMyTodoRepository();
    myTodoBloc = MyTodoBloc(repository);
  });

  group('TodoBloc test', () {
    const tTodo = 'wash my car';
    final tTodoModel = MyTodoModel(
      id: 151,
      todo: tTodo,
      completed: false,
      userId: 5,
    );

    blocTest<MyTodoBloc, MyTodoState>(
      'emits [MyTodoLoading, TodoAdded] when AddTodo is added and succeeds',
      build: () {
        when(repository.addTodo(
                todo: anyNamed('todo'),
                completed: anyNamed('completed'),
                userId: anyNamed('userId')))
            .thenAnswer((_) async => right(tTodoModel));
        return myTodoBloc;
      },
      act: (bloc) => bloc.add(AddTodoEvent(
        todo: tTodoModel.todo,
        completed: 0,
        userId: 5,
      )),
      expect: () => [
        MyTodoLoading(),
        AddTodoSuccessState(tTodoModel),
      ],
    );
  });
}
