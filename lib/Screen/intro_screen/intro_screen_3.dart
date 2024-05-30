import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/style.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ic_slider_2,
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            onboaringScreentext3,
            style: onboardingScreen,
          ),
        ],
      ),
    );
  }
}
