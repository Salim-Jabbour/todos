// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/services/debug_print.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/todo_card_widget.dart';
import '../../../my_tasks/models/my_todo_model.dart';
import '../bloc/all_todos_bloc.dart';

class AllTodosPage extends StatefulWidget {
  const AllTodosPage({super.key});

  @override
  State<AllTodosPage> createState() => _AllTodosPageState();
}

class _AllTodosPageState extends State<AllTodosPage> {
  List<MyTodoModel>? todosList = [];
  int skip = 0;
  int limit = 10;
  // pagination related
  final AllTodosBloc _bloc = AllTodosBloc(GetIt.I.get());
  ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  int currentPage = 1;
  int total = 10000000;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 220.h &&
        !isLoadingMore &&
        skip < total) {
      setState(() {
        isLoadingMore = true;
      });
      _bloc.add(GetAllPaginatedTodosEvent(limit: limit, skip: skip));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<AllTodosBloc, AllTodosState>(
        listener: (context, state) {
          if (state is GetAllTodosSuccessState) {
            dbg("SSSSSSSSSSSSSSSSSSSSSSss");

            setState(() {
              todosList = state.allTodos.todos;
              skip = state.allTodos.todos.length;
              total = state.allTodos.total;
            });
            dbg(total);
          }
          if (state is GetPaginatedTodosSuccessState) {
            setState(() {
              todosList!.addAll(state.allTodos.todos);
              skip += state.allTodos.limit;
              isLoadingMore = false;
            });
            dbg(skip);
          }
          if (state is GetPaginatedTodosFailedState) {
            setState(() {
              isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          if (state is AllTodosInitial) {
            context.read<AllTodosBloc>().add(GetAllTodosEvent());
          }
          if (state is GetAllTodosFailedState) {
            return FailureWidget(
              errorMessage: state.failure.message,
              onPressed: () {},
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.blue,
              elevation: 3,
              leadingWidth: 50.w,
              centerTitle: true,
              title: Text(StringManager.allTasks),
            ),
            backgroundColor: ColorManager.backgroundL,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              todosList!.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == todosList!.length) {
                              return const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child:  Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                            return TodoCardWidget(
                              id: todosList?[index].id ?? 1,
                              todo: todosList?[index].todo ??
                                  'Paint the first thing I see',
                              completed: todosList?[index].completed ?? true,
                              userId: todosList?[index].userId ?? 5,
                              mytodo: false,
                            );
                          }),
                    ),
                  ],
                ),
                if (state is AllTodosLoading)
                  const LoadingWidget(
                    fullScreen: true,
                  )
                else if (state is GetAllTodosSuccessState && todosList!.isEmpty)
                  EmptyWidget(height: 1.sh - 0.1.sh),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
