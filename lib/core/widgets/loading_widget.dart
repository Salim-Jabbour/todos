import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../config/theme/color_manager.dart';
import '../resource/string_manager.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.fullScreen = false,
  });
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 1.sw,
      color: fullScreen == true ? Colors.white54 : Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: LoadingAnimationWidget.inkDrop(
                color: ColorManager.blue,
                size: 45.sp,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Text(
              StringManager.loading,
              style: TextStyle(
                color: ColorManager.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
