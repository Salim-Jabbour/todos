import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/asset_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/bottom_navigation_bar_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/my_todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController todoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool visibility = false;

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundL,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => GetIt.I.get<MyTodoBloc>(),
            child: BlocConsumer<MyTodoBloc, MyTodoState>(
              listener: (context, state) {
                if (state is AddTodoFailedState) {
                  gShowErrorSnackBar(
                      context: context, message: state.failure.message);
                }
                if (state is AddTodoSuccessState) {
                  gShowSuccessSnackBar(
                      context: context,
                      message: StringManager.todoAddedSuccessfully);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BottomNavigationBarWidget()));
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 60.h),
                            child: Image.asset(
                              AssetImageManager.todo,
                              fit: BoxFit.fill,
                              height: 200.h,
                              width: 200.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 100.h),
                        // username textfield
                        CustomTextField(
                          height: 150.h,
                          width: 350.w,
                          keybordType: TextInputType.name,
                          hintText: StringManager.todo,
                          icon: Icons.add_task_rounded,
                          textEditingController: todoController,
                          suffixIconWidget: null,
                          visibility: false,
                          textFieldColor: Colors.grey.withOpacity(0.3),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringManager.pleaseEnterTodo;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 60.h,
                        ),

                        CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<MyTodoBloc>().add(AddTodoEvent(
                                    todo: todoController.text,
                                    completed: 0,
                                    userId: int.parse(
                                        context.read<AuthBloc>().id ?? '12'),
                                  ));
                            }
                          },
                          text: StringManager.addTodo,
                        ),
                      ],
                    ),
                    if (state is MyTodoLoading)
                      const LoadingWidget(
                        fullScreen: true,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
