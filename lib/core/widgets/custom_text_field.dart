import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';

class CustomTextField extends StatelessWidget {
  final double width;
  final String? hintText;
  final IconData icon;
  final TextEditingController textEditingController;
  final Widget? suffixIconWidget;
  final bool? visibility;
  final TextInputType keybordType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onFieldSubmittedFunc;
  final Color? textFieldColor;
  final String? initialValue;
  final bool? enabled;
  final double? height;
  final bool isAuth;

  const CustomTextField({
    required this.keybordType,
    required this.width,
    this.hintText,
    required this.icon,
    required this.textEditingController,
    this.suffixIconWidget,
    this.visibility,
    required this.validator,
    this.onFieldSubmittedFunc,
    super.key,
    this.textFieldColor,
    this.initialValue,
    this.enabled,
    this.height,
    required this.isAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: width,
        height: height ?? 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: textFieldColor ??
              ColorManager.textFieldFill, // Adjust the color to your preference
        ),
        child: TextFormField(
          enabled: enabled,
          maxLines: visibility == true ? 1 : null,
          minLines: visibility == true ? 1 : null,
          expands: isAuth == true ? false : true,
          initialValue: initialValue,
          controller: textEditingController,
          keyboardType: keybordType,
          obscureText: visibility ?? false,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            hintText: hintText,
            focusedBorder: !isAuth
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: const BorderSide(color: Colors.black),
                  )
                : const OutlineInputBorder(borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: !isAuth
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  )
                : const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: Icon(
              icon,
              color: ColorManager.foregroundL,
              size: 20.sp,
            ),
            suffixIcon: suffixIconWidget ?? suffixIconWidget,
          ),
          validator: validator,
          onFieldSubmitted: onFieldSubmittedFunc,
        ),
      ),
    );
  }
}
