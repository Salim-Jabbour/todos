import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/asset_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/bottom_navigation_bar_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool visibility = false;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundL,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailed) {
                gShowErrorSnackBar(
                    context: context, message: state.failure.message);
              }
              if (state is AuthSuccess) {
                gShowSuccessSnackBar(
                    context: context,
                    message: StringManager.loggedInSuccessfully);
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
                          padding: EdgeInsets.symmetric(vertical: 150.h),
                          child: Image.asset(
                            AssetImageManager.logo,
                            fit: BoxFit.fill,
                            height: 150.h,
                            width: 150.h,
                          ),
                        ),
                      ),
                      // username textfield
                      CustomTextField(
                        width: 350.w,
                        keybordType: TextInputType.name,
                        hintText: StringManager.userNameHintText,
                        icon: Icons.person,
                        textEditingController: userNameController,
                        suffixIconWidget: null,
                        visibility: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringManager.pleaseEnterUserName;
                          }
                          return null;
                        },
                        isAuth: true,

                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      CustomTextField(
                        width: 350.w,
                        keybordType: TextInputType.visiblePassword,
                        hintText: StringManager.password,
                        icon: Icons.lock,
                        textEditingController: passwordController,
                        suffixIconWidget: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                            icon: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ColorManager.foregroundL,
                            ),
                          ),
                        ),
                        visibility: visibility,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringManager.pleaseEnterYourPassword;
                          }
                          return null;
                        },
                        isAuth: true,
                      ),

                      SizedBox(
                        height: 40.h,
                      ),

                      CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLoginEvent(
                                  username: userNameController.text,
                                  password: passwordController.text,
                                ));
                          }
                        },
                        text: StringManager.login,
                      ),
                    ],
                  ),
                  if (state is AuthLoading)
                    const LoadingWidget(
                      fullScreen: true,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
