import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme/color_manager.dart';
import '../resource/asset_manager.dart';
import '../resource/string_manager.dart';
import 'custom_button.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget(
      {super.key, required this.errorMessage, required this.onPressed});
  final String errorMessage;
  final dynamic Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 1.sw,
      color: ColorManager.backgroundL,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            AssetJsonManager.error,
            height: 200.h,
          ),
          Text(
            errorMessage,
            style: TextStyle(
                color: ColorManager.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 50.h,
          ),
          CustomButton(onPressed: onPressed, text: StringManager.tryAgain)
        ],
      ),
    );
  }
}
