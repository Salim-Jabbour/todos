import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/debug_print.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/todo_card_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/page/profile_page.dart';
import '../../data/datasource/local/my_todo_local_data_source.dart';
import '../../models/my_todo_model.dart';
import '../bloc/my_todo_bloc.dart';

class MyTodosPage extends StatefulWidget {
  const MyTodosPage({super.key});

  @override
  State<MyTodosPage> createState() => _MyTodosPageState();
}

class _MyTodosPageState extends State<MyTodosPage> {
  List<MyTodoModel>? todosList;
  MyTodoLocalDataSource? _myTodoLocalDataSource;
  @override
  void dispose() {
    _myTodoLocalDataSource?.closeDb();
    dbg("CLOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<MyTodoBloc>(),
      child: BlocConsumer<MyTodoBloc, MyTodoState>(
        listener: (context, state) {
          if (state is GetTodosSuccessState) {
            todosList = state.myTodos.todos;
          }
          if (state is RefreshTokenSuccessState) {
            gShowSuccessSnackBar(
                context: context, message: StringManager.refreshedSuccessfully);
          }
          if (state is DeleteTodoSuccessState) {
            gShowSuccessSnackBar(
                context: context, message: StringManager.deletedSuccessfully);
          }
          if (state is UpdateTodoSuccessState) {
            gShowSuccessSnackBar(
                context: context, message: StringManager.updatedSuccessfully);
          }
        },
        builder: (context, state) {
          if (state is MyTodoInitial) {
            context.read<MyTodoBloc>().add(GetTodosEvent(
                  userId: context.read<AuthBloc>().id ?? '5',
                ));
          }
          if (state is GetTodosFailedState) {
            return FailureWidget(
              errorMessage: state.failure.message,
              onPressed: () {
                // refresh token
                context.read<MyTodoBloc>().add(TodoRefreshTokenEvent(
                    context.read<AuthBloc>().token ?? ''));
                // then retry
                context.read<MyTodoBloc>().add(GetTodosEvent(
                      userId: context.read<AuthBloc>().id ?? '5',
                    ));
              },
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.blue,
              elevation: 3,
              leadingWidth: 50.w,
              centerTitle: true,
              title: Text(StringManager.myTasks),
              leading: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()));
                  },
                  child: Tooltip(
                    message: StringManager.profile,
                    preferBelow: true,
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        // radius: 15,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: Tooltip(
                    message: StringManager.refreshedToken,
                    preferBelow: true,
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          context.read<MyTodoBloc>().add(TodoRefreshTokenEvent(
                              context.read<AuthBloc>().token ?? ''));
                        },
                        icon: Icon(
                          Icons.change_circle,
                          color: ColorManager.blue,
                          size: 35.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: ColorManager.backgroundL,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: todosList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TodoCardWidget(
                              id: todosList?[index].id ?? 1,
                              todo: todosList?[index].todo ??
                                  'Paint the first thing I see',
                              completed: todosList?[index].completed ?? true,
                              userId: todosList?[index].userId ?? 5,
                              mytodo: true,
                            );
                          }),
                    ),
                  ],
                ),
                if (state is MyTodoLoading)
                  const LoadingWidget(
                    fullScreen: true,
                  )
                else if (state is GetTodosSuccessState && todosList!.isEmpty)
                  EmptyWidget(height: 1.sh - 0.1.sh),
              ],
            ),
          );
        },
      ),
    );
  }
}
