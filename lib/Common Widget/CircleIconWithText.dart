import 'package:flutter/material.dart';
import 'package:v_doctor/utils/colors.dart';

class CircleIconWithText extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String? text;

  const CircleIconWithText({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
        SizedBox(height: 10), // Add spacing between the icon and the text
        if (text != null)
          Text(
            text!,
            style: TextStyle(color: ColorConstants.white),
          ),
      ],
    );
  }
}
