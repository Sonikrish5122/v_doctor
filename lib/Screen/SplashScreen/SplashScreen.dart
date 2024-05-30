import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_doctor/Common%20Widget/LogoTitle.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Doctor/DoctorHomeScreen.dart';
import 'package:v_doctor/Screen/OnboardingScreen/OnboardingScreen.dart';
import 'package:v_doctor/Screen/Patient/PatientHomeScreen.dart';
import 'package:v_doctor/utils/SessionManager.dart';

import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';
import 'package:v_doctor/utils/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        checkUserLoginStatus().then((isLoggedIn) {
          if (isLoggedIn) {
            Get.to(DoctorHomeScreen());
          } else {
            Get.to(OnboardingScreen());
          }
        });
      },
    );
  }

  Future<bool> checkUserLoginStatus() async {
    SessionManager sessionManager = SessionManager();
    UserData? userData = await sessionManager.getUserInfo();
    return userData != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoTitle(),
            SizedBox(height: 5),
            Text(
              splashScreenText,
              style: continueas.copyWith(
                color: ColorConstants.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
