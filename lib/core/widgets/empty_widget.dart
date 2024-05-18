import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme/color_manager.dart';
import '../resource/asset_manager.dart';
import '../resource/string_manager.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: height.h,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            AssetJsonManager.empty,
            height: 300.h,
          ),
          Text(
            StringManager.noTasks,
            style: TextStyle(
                color: ColorManager.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
