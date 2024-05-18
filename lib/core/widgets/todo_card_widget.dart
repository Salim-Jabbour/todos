import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task_manager_app_test/config/theme/color_manager.dart';

import '../../features/my_tasks/presentation/bloc/my_todo_bloc.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget({
    super.key,
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        height: 200.h,
        width: 350.w,
        decoration: BoxDecoration(
            color: completed
                ? ColorManager.green.withOpacity(0.8)
                : ColorManager.red.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: ColorManager.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(18.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<MyTodoBloc>().add(UpdateTodoEvent(
                          completed: !completed,
                          todoId: id.toString(),
                        ));
                  },
                  icon: Icon(
                    Icons.change_circle_outlined,
                    color: ColorManager.blue,
                    size: 30.sp,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 0.w),
                  child: IconButton(
                    onPressed: () {
                      context.read<MyTodoBloc>().add(
                            DeleteTodoEvent(todoId: id.toString()),
                          );
                    },
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 30.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                todo,
                style:
                    TextStyle(fontSize: 20.sp, color: ColorManager.foregroundL),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
