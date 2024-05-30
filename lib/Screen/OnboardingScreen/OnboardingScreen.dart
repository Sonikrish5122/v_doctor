import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v_doctor/Screen/SelectOption/SelectOption.dart';
import 'package:v_doctor/Screen/intro_screen/intro_screen_1.dart';
import 'package:v_doctor/Screen/intro_screen/intro_screen_2.dart';
import 'package:v_doctor/Screen/intro_screen/intro_screen_3.dart';

import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

import '../intro_screen/intro_screen_4.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [
              IntroScreen1(),
              IntroScreen2(),
              IntroScreen3(),
              IntroScreen4(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.blue,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8,
                      expansionFactor: 2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: onLastPage
                          ? TextButton(
                              onPressed: () {
                                Get.to(SelectOptionScreen());
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  ColorConstants.primaryColor,
                                ),
                              ),
                              child: Text(
                                onboaringbutton.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                Get.to(SelectOptionScreen());
                                throw Exception();
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15),
                                ),
                              ),
                              child: Text(
                                "Skip".toUpperCase(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
