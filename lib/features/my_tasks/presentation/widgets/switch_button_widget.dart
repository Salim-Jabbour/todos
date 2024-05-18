import 'package:flutter/material.dart';

import '../../../../config/theme/color_manager.dart';

class SwitchButtonWidget extends StatefulWidget {
  const SwitchButtonWidget({super.key});
  @override
  State<SwitchButtonWidget> createState() => _SwitchButtonWidgetState();
}

class _SwitchButtonWidgetState extends State<SwitchButtonWidget> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Completed: ${_switchValue ? "ON" : "OFF"}'),
          Switch(
            activeColor: ColorManager.green,
            inactiveThumbColor: ColorManager.red,
            inactiveTrackColor: ColorManager.red.withOpacity(0.2),
            value: _switchValue,
            onChanged: (bool newValue) {
              setState(() {
                _switchValue = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
