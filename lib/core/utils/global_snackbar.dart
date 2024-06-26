import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> gShowErrorSnackBar(
    {required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
            size: 25.sp,
          ),
          SizedBox(width: 80.w),
          SizedBox(
            width: 1.sw - 250.w,
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      duration: const Duration(seconds: 3),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> gShowSuccessSnackBar(
    {required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.done,
            color: Colors.white,
            size: 25.sp,
          ),
          SizedBox(width: 80.w),
          SizedBox(
            width: 1.sw - 250.w,
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightGreenAccent.shade700,
      duration: const Duration(seconds: 3),
    ),
  );
}
