import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';
import '../resource/const_manager.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.task_alt_rounded,
              size: 30.sp,
            ),
            label: "My Tasks",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_rounded,
              size: 30.sp,
            ),
            label: "Add",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.task_rounded,
              size: 30.sp,
            ),
            label: "Tasks",
          ),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: ColorManager.grey.withOpacity(0.5),
        surfaceTintColor: Colors.blue,
      ),
      body: ConstManager.pageOptions[currentPageIndex],
    );
  }
}
