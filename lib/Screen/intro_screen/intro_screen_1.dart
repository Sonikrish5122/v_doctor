import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/style.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ic_slider_3,
            width: 200,
            height: 200,
          ),
          SizedBox(height: 40),
          Text(
            onboaringScreentext1,
            style: onboardingScreen,
          ),
        ],
      ),
    );
  }
}
