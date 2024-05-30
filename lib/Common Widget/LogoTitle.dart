import 'package:flutter/material.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/style.dart';
import '../../utils/colors.dart';

class LogoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          app_logo,
          height: 200,
        ),
        SizedBox(height: 10),
        Text(
          logotiltle,
          style: logotilte.copyWith(color: ColorConstants.secondaryAppColor),
        ),
      ],
    );
  }
}
