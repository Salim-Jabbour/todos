import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/todo_card_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../my_tasks/models/my_todo_model.dart';
import '../../../my_tasks/presentation/bloc/my_todo_bloc.dart';
import '../../model/user_profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../widget/profile_info_row_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileModel? userModel;
  MyTodoModel? myTodoModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<ProfileBloc>(),
      child: Scaffold(
        backgroundColor: ColorManager.backgroundL,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile page'),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileGetRandomTodoSuccess) {
              myTodoModel = state.myTodoModel;
            }
            if (state is ProfileGetUserSuccess) {
              userModel = state.userModel;
            }
          },
          builder: (context, state) {
            if (state is ProfileInitial) {
              context.read<ProfileBloc>().add(ProfileGetCurrentUserEvent(
                  context.read<AuthBloc>().token ?? ''));
              context.read<ProfileBloc>().add(GetRandomTodoEvent());
            }
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 60.sp,
                        backgroundImage: NetworkImage(userModel?.image ??
                            'https://robohash.org/Terry.png?set=set4'),
                      ),
                      SizedBox(height: 20.h),
                      ProfileInfoRow(
                        icon: Icons.email,
                        title: 'Email',
                        value: userModel?.email ?? 'atuny0@sohu.com',
                      ),
                      SizedBox(height: 20.h),

                      ProfileInfoRow(
                        icon: Icons.person,
                        title: 'Username',
                        value: userModel?.username ?? 'atuny0',
                      ),
                      SizedBox(height: 20.h),

                      // Full Name
                      ProfileInfoRow(
                        icon: Icons.person_outline,
                        title: 'Full Name',
                        value:
                            "${userModel?.firstName ?? 'Terry'} ${userModel?.lastName ?? 'Medhurst'}",
                      ),
                      SizedBox(height: 20.h),

                      // Gender
                      ProfileInfoRow(
                        icon: userModel?.gender == 'male'
                            ? Icons.male
                            : Icons.female,
                        title: 'Gender',
                        value: userModel?.gender == 'male' ? 'Male' : 'Female',
                      ),

                      SizedBox(height: 20.h),
                      TodoCardWidget(
                        id: myTodoModel?.id ?? 1,
                        todo:
                            myTodoModel?.todo ?? 'Paint the first thing I see',
                        completed: myTodoModel?.completed ?? false,
                        userId: myTodoModel?.userId ?? 5,
                      ),
                      SizedBox(height: 10.h),

                      Tooltip(
                        message: 'Random Task',
                        preferBelow: true,
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<ProfileBloc>()
                                  .add(GetRandomTodoEvent());
                            },
                            icon: Icon(
                              Icons.change_circle,
                              color: ColorManager.blue,
                              size: 45.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is ProfileLoading)
                  const LoadingWidget(
                    fullScreen: true,
                  ),
                if (state is ProfileGetUserFailed)
                  FailureWidget(
                      errorMessage: state.failure.message,
                      onPressed: () {
                        context.read<MyTodoBloc>().add(TodoRefreshTokenEvent(
                            context.read<AuthBloc>().token ?? ''));
                      })
              ],
            );
          },
        ),
      ),
    );
  }
}
